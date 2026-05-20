import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_vendor_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/vendor_card.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../shared/widgets/empty_state.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _vendorService = MockVendorService();
  List<VendorModel> _vendors = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final vendors = await _vendorService.getFavourites();
    setState(() {
      _vendors = vendors;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favourites')),
      body: _loading
          ? const Padding(padding: EdgeInsets.all(16), child: ShimmerList())
          : _vendors.isEmpty
              ? EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: 'No favourites yet',
                  subtitle: 'Save vendors you love and find them here.',
                  buttonLabel: 'Explore Vendors',
                  onButtonTap: () => context.go(AppRoutes.explore),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _vendors.length,
                  itemBuilder: (context, i) => VendorListCard(
                    vendor: _vendors[i],
                    onTap: () => context.push(AppRoutes.vendorProfilePath(_vendors[i].id)),
                  ),
                ),
    );
  }
}
