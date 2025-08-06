import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/presentation/widgets/dashboard/home_header.dart';
import 'package:innerix/presentation/widgets/dashboard/item_heading.dart';
import 'package:innerix/presentation/widgets/dashboard/offer_banner.dart';
import 'package:innerix/presentation/widgets/dashboard/search_field.dart';
import 'package:innerix/service/category_list.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    final categories = getCategory(); 
    
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea( // Added SafeArea for better spacing
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
          
              const HomeHeader(),
          
              const SizedBox(height: 10),
                  
              const CustomSearchField(),
                  
              const SizedBox(height: 10),
          
              const HomeBanner(),
          
              const SizedBox(height: 15),
          
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
                  
              const ItemHeading(txt: "Top Selling", txtto: "View All"),
                  
              const SizedBox(height: 10),  
                  
              const Expanded( // Wrap with Expanded to prevent overflow
                child: SingleChildScrollView(
                  child: CustomProductCard()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








// Your existing CustomProductCard class remains the same
class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0,top: 10),
      child: Container(
            width: 160,
            height: 250,
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 25,
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/flower.png",height: 130,width: 130,),
                  const Text(
                    "Title",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  const Text(
                    "RS.",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/star.png",height: 11,width: 11,),
                      const Text("4.6",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 10
                      ),
                      ),
                      const Text(
                        "86 Reviews",
                        style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 10
                      ),
                        ),
                      const Icon(Icons.more_vert,size: 14,color: AppColors.grey,)
                    ],
                  )
                ],
              ),
            ),
          ),
    );
  }
}