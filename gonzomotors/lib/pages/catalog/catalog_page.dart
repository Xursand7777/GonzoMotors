import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
      ),
      body: CatalogPageView(platform: platform),
    );
  }
}

class CatalogPageView extends StatefulWidget {
  final TargetPlatform platform;

  const CatalogPageView({super.key, required this.platform});

  @override
  State<CatalogPageView> createState() => _CatalogPageViewState();
}

class _CatalogPageViewState extends State<CatalogPageView> {
  @override
  void initState() {
    super.initState();
    // тут можно вызвать загрузку, например bloc/cubit event
    // context.read<CatalogBloc>().add(LoadCatalog());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Platform: ${widget.platform}'),
    );
  }
}
