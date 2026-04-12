import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/gen/assets.gen.dart';

import '../../core/di/app_injection.dart';
import '../../core/route/route_names.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import 'cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(sl.get()),
        ),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
             icon: Icon(Icons.dark_mode_outlined, color: Colors.black),
             onPressed: () {},
          )
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status.isLoading()) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final phone = state.user?.phone ?? '+998 ( _ _ ) _ _ _  _ _  _ _';

          return RefreshIndicator.adaptive(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              context.read<ProfileBloc>().add(const GetProfileEvent());
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
                child: Column(
                  children: [
                    // Profile Header Card
                    GestureDetector(
                      onTap: () {
                         context.pushNamed(RouteNames.editProfile);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade200,
                              child: const Icon(Icons.person, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    phone,
                                    style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Вы вошли с помошью телефон номера',
                                    style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xff797979)),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Grid of Menu Items
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1, // To make them square-like
                      children: [
                        _buildGridItem(
                          iconPath: Assets.icons.heart.path,
                          title: 'Избранные',
                          onTap: () {},
                        ),
                        _buildGridItem(
                          iconPath: Assets.icons.magazine.path,
                          title: 'Мои заказы',
                          onTap: () {},
                        ),
                        _buildGridItem(
                          iconPath: Assets.icons.notification.path,
                          title: 'Уведомления',
                          onTap: () {},
                        ),
                        _buildGridItem(
                          iconPath: Assets.icons.message.path,
                          title: 'Ответы на\nвопросы',
                          onTap: () {},
                        ),
                        _buildGridItem(
                          iconPath: Assets.icons.phone.path,
                          title: 'Свяжитесь с нами',
                          onTap: () {},
                        ),
                        _buildGridItem(
                          iconPath: Assets.icons.settings.path,
                          title: 'Тема',
                          onTap: () {},
                        ),
                        _buildGridItem(
                          iconPath: Assets.icons.premium.path,
                          title: 'Банк и калькулятор',
                          onTap: () {},
                        ),
                        _buildGridItem(
                          iconPath: Assets.icons.profile.path,
                          title: 'О Gonzo Motors',
                          onTap: () {},
                        ),
                        _buildGridItem(
                           iconPath: Assets.icons.logOut.path,
                           title: 'Выйти',
                           onTap: () {
                             // context.read<ProfileBloc>().add(const UserLoggedOutEvent());
                             context.pushNamed(RouteNames.auth);
                           },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 28,
              height: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
