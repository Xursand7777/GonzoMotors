# GonzoMotors Architecture & Integration Guide

This document provides a comprehensive overview of the GonzoMotors mobile application and its integration with the backend server. It serves as a master guide for development, debugging, and architecture rules.

---

## 📱 Mobile App Architecture (Flutter)

The GonzoMotors mobile app is written in Dart using Flutter. It is structured around modern, modular architecture principles.

### 1. State Management
We use **flutter_bloc** (BLoC and Cubit patterns) for separating business logic from the UI.
*   **FilterOptionsCubit** (`lib/features/car_catalog/bloc/filter_options_cubit.dart`): Handles loading and managing all filter items (brands, body types, drive types, etc.).
*   **FilterCubit** (`lib/features/car_catalog/bloc/filter_cubit.dart`): Tracks the user's active filter selections (e.g. selected powertrain, body type, or brand).
*   **CarCatalogBloc** (`lib/features/car_catalog/bloc/car_catalog_bloc.dart`): Fetches and paginates car card lists based on active `CarQueryOptions`.
*   **ProfileBloc** (`lib/features/profile/bloc/profile_bloc.dart`): Renders user profile information, checks application versions, and handles authentication/logout workflows.

### 2. Dependency Injection (DI)
We use **GetIt** (`lib/core/di/app_injection.dart`) to manage and inject singleton services and repositories (e.g. `sl.get<FilterOptionsRepository>()`).
*   Always register new repositories or services in `initInjection()` to make them injectable.

### 3. Networking & HTTP Client
The network layer is managed by **Dio** (`lib/core/network/dio_client.dart`).
*   **Base URL**: Configured as `http://zachir.uz/api/`.
*   **Interceptors**:
    *   `ApiResponseInterceptor`: Automatically attaches the access token (`Authorization: Bearer <token>`), FCM token (`fcm-token`), and device details (`device-id`, `name`, `model`) to every outbound request.
    *   It also intercepts `401 Unauthorized` responses and performs an automatic token refresh using the `auth/refresh` endpoint.
    *   `TalkerDioLogger`: Provides detailed logs for request and response diagnostics.

> [!WARNING]
> **Dio URL Resolution Rule**: Under RFC 3986, paths starting with a leading slash `/` resolve absolute to the host authority (e.g. `/Cars/filter-options` resolves to `http://zachir.uz/Cars/filter-options` instead of appending to `baseUrl`'s path).
> **Never use leading slashes in API paths inside repository files.** Use relative paths (e.g. `'Cars/filter-options'`).

---

## 🖥️ Backend Architecture (.NET Web API)

The backend is built using C# and ASP.NET Core, located at `C:\Users\user\source\repos\GonzoMotors`.

### 1. Solution Structure (`GonzoMotors.sln`)
*   **GonzoMotors.Api**: Houses the API controllers (e.g., `CarsController.cs` under `/Controllers/Common/`).
*   **GonzoMotors.Application**: Contains the service interfaces and implementations (e.g., `CarService.cs` which manages CRUD actions and filter option loading).
*   **GonzoMotors.Domain**: Defines the database models and entities (e.g. `CarBodyTypeEntity`, `CarBrandEntity`, `CarEntity`).
*   **GonzoMotors.Infrastructure**: Handles the database connection (`GonzoMotorsDbContext`), migrations, and seeds the database with initial static lookup data.

### 2. Seeding Lookup Data
Lookups are pre-seeded in EF Core migrations (located in `GonzoMotors.Infrastructure/Seed/`):
*   `CarBodyTypeSeed.cs`: Seeds Russian/Uzbek names for body types (e.g., `id: 1` = Седан, `id: 10` = Кроссовер, `id: 11` = Внедорожник).
*   `CarDriveTypeSeed.cs`, `CarEngineTypeSeed.cs`, `CarFuelTypeSeed.cs`: Seed drive types, engines, and fuel configurations.

### 3. Current Integration Fallbacks
*   **Outdated Remote Server**: The remote production server `http://zachir.uz` currently runs an older version of the backend and does not expose the `/api/Cars/filter-options` endpoint.
*   **Mobile App Fallback**: If the server returns a 404 for `/Cars/filter-options`, the mobile repository automatically falls back to static seed data, ensuring the Catalog UI works beautifully under all environments.
