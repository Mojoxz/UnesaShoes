import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sepatu_client/controller/home_controller.dart';
import 'package:sepatu_client/pages/product_description.dart';
import 'package:sepatu_client/widgets/DropDown_btn.dart';
import 'package:sepatu_client/widgets/multi_select_dropDown.dart';
import 'package:sepatu_client/widgets/product_cart.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProduct();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0), // Mengurangi jarak bawah
              child: Center(
                child: Text(
                  'Beranda',
                  style: TextStyle(
                    fontSize: 28, // Ukuran font yang lebih besar untuk penekanan
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ctrl.productCategories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      ctrl.filterByCategory(ctrl.productCategories[index].name ?? '');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Chip(
                        label: Text(ctrl.productCategories[index].name ?? 'error'),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: DropDownBTN(
                    items: ['Rp: Terendah ke Tertinggi', 'Rp: Tertinggi ke Terendah'],
                    selectedItemText: 'Sortir',
                    onSelected: (selected) {
                      ctrl.sortByPrice(ascending: selected == 'Rp: Tertinggi ke Terendah' ? false : true);
                    },
                  ),
                ),
                Flexible(
                  child: MultiSelectDropdown(
                    items: ['Sketchers', 'Puma', 'Adidas', 'Clraks', 'Onitsuka', 'Reebok', 'Timberland'],
                    onSelectionChanged: (selectedItems) {
                      ctrl.filterByBrand(selectedItems);
                    },
                  ),
                )
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: ctrl.productShowinUI.length,
                itemBuilder: (context, index) {
                  return ProductCart(
                    name: ctrl.productShowinUI[index].name ?? 'Tidak ada nama',
                    imageUrl: ctrl.productShowinUI[index].image ?? 'Tidak ada gambar',
                    price: ctrl.productShowinUI[index].price ?? 00,
                    offerTag: 'Diskon 20 %',
                    onTap: () {
                      Get.to(ProductDescription(), arguments: {'data': ctrl.productShowinUI[index]});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
