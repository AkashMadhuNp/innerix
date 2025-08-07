import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/presentation/bloc/home/bloc/home_bloc.dart';
import 'package:innerix/presentation/bloc/home/bloc/home_event.dart';
import 'package:innerix/presentation/bloc/home/bloc/home_state.dart';
import 'package:innerix/presentation/widgets/dashboard/custom_product_card.dart';
import 'package:innerix/presentation/widgets/dashboard/home_header.dart';
import 'package:innerix/presentation/widgets/dashboard/item_heading.dart';
import 'package:innerix/presentation/widgets/dashboard/offer_banner.dart';
import 'package:innerix/presentation/widgets/dashboard/search_field.dart';
import 'package:innerix/service/category_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = getCategory();
    
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(RefreshHomeData());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 10),
                  const CustomSearchField(),
                  const SizedBox(height: 10),
                  const HomeBanner(),
                  const SizedBox(height: 15),
                  
                  // Categories section
                  const ItemHeading(
                    txt: "Categories",
                    txtto: "See All",
                  ),
                  const SizedBox(height: 10),
                  _buildCategoriesSection(categories),
                  
                  const SizedBox(height: 20),
                  
                  // Top Selling section
                  const ItemHeading(txt: "Top Selling", txtto: "View All"),
                  const SizedBox(height: 10),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return _buildProductSection(
                        context,
                        state,
                        (homeData) => homeData.topSellingItems,
                        'No top selling items available',
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Best Offers section
                  const ItemHeading(txt: "Best Offers", txtto: "View All"),
                  const SizedBox(height: 10),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return _buildProductSection(
                        context,
                        state,
                        (homeData) => homeData.bestOffers,
                        'No best offers available',
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(List categories) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 17.0),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(category.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  category.name!,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductSection(
    BuildContext context,
    HomeState state,
    List Function(dynamic) getProducts,
    String emptyMessage,
  ) {
    if (state is HomeLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is HomeError) {
      return Center(
        child: Column(
          children: [
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(LoadHomeData());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is HomeLoaded) {
      final products = getProducts(state.homeData);
      if (products.isEmpty) {
        return Center(
          child: Text(emptyMessage),
        );
      }
      return SizedBox(
        height: 248,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CustomProductCard(product: product),
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}