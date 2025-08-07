import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/presentation/widgets/dashboard/custom_product_card.dart';
import 'package:innerix/presentation/widgets/dashboard/home_header.dart';
import 'package:innerix/presentation/widgets/dashboard/item_heading.dart';
import 'package:innerix/presentation/widgets/dashboard/offer_banner.dart';
import 'package:innerix/presentation/widgets/dashboard/search_field.dart';
import 'package:innerix/service/category_list.dart';
import 'package:innerix/service/api_service.dart'; 
import 'package:innerix/model/product_model.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeData? homeData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      
      final data = await ApiService.getHomeData();
      setState(() {
        homeData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = getCategory(); 
    
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView( 
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
                SizedBox(
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
                                  image: AssetImage(categories[index].image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              categories[index].name!,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: AppColors.black
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Top Selling section
                const ItemHeading(txt: "Top Selling", txtto: "View All"),
                const SizedBox(height: 10),
                
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Error: $errorMessage',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: fetchHomeData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (homeData?.topSellingItems.isEmpty ?? true)
                  const Center(
                    child: Text('No top selling items available'),
                  )
                else
                  SizedBox(
                    height: 248,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: homeData!.topSellingItems.length,
                      itemBuilder: (context, index) {
                        final product = homeData!.topSellingItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: CustomProductCard(product: product),
                        );
                      },
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                // Best Offers section
                const ItemHeading(txt: "Best Offers", txtto: "View All"),
                const SizedBox(height: 10),
                
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Error: $errorMessage',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: fetchHomeData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (homeData?.bestOffers.isEmpty ?? true)
                  const Center(
                    child: Text('No best offers available'),
                  )
                else
                  SizedBox(
                    height: 248,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: homeData!.bestOffers.length,
                      itemBuilder: (context, index) {
                        final product = homeData!.bestOffers[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: CustomProductCard(product: product),
                        );
                      },
                    ),
                  ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


