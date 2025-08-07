import 'package:flutter/material.dart';
import 'package:innerix/core/constants/colors.dart';
import 'package:innerix/model/product_model.dart';
import 'package:lottie/lottie.dart';

class CustomProductCard extends StatelessWidget {
  final Product product;
  
  const CustomProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 248,
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: product.thumbnailImage != null && product.thumbnailImage!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.thumbnailImage!,
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/flower.png",
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                      ),
                    )
                  :Lottie.asset(
                    "assets/Empty box.json",
                    height: 130,
                    width: 130
                    )
            ),
            
            
            Text(
              product.name,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                letterSpacing: 0.2,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            
            Text(
              "RS. ${product.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                letterSpacing: 0.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/star.png", height: 11, width: 11),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 10,
                  ),
                ),

                SizedBox(width: 10,),
                Expanded(
                  child: Text(
                    "${product.reviews} Reviews",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: AppColors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}