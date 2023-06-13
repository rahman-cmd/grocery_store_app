
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/controller/expense_controller.dart';
import 'package:sixam_mart_store/helper/date_converter.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/view/base/custom_app_bar.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/expence/widget/expense_card.dart';
class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<ExpenseController>().initSetDate();
    Get.find<ExpenseController>().setOffset(1);

    Get.find<ExpenseController>().getExpenseList(
      offset: Get.find<ExpenseController>().offset.toString(),
      from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to,
      searchText: Get.find<ExpenseController>().searchText,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<ExpenseController>().expenses != null
          && !Get.find<ExpenseController>().isLoading) {
        int pageSize = (Get.find<ExpenseController>().pageSize! / 10).ceil();
        if (Get.find<ExpenseController>().offset < pageSize) {
          Get.find<ExpenseController>().setOffset(Get.find<ExpenseController>().offset+1);
          debugPrint('end of the page');
          Get.find<ExpenseController>().showBottomLoader();
          Get.find<ExpenseController>().getExpenseList(
            offset: Get.find<ExpenseController>().offset.toString(),
            from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to,
            searchText: Get.find<ExpenseController>().searchText,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'expense_report'.tr),
      body: GetBuilder<ExpenseController>(
        builder: (expenseController) {
          return Column(children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.radiusDefault, vertical: Dimensions.radiusDefault),
              child: Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                    child: GetBuilder<ExpenseController>(
                      builder: (expenseController) {
                        return TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'search_with_order_id'.tr,
                            suffixIcon: IconButton(
                              icon: Icon(expenseController.searchMode ? Icons.clear : Icons.search),
                              onPressed: (){
                                if(!expenseController.searchMode){
                                  if(_searchController.text.isNotEmpty){
                                    expenseController.setSearchText(offset: '1', from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to, searchText: _searchController.text);
                                  }else{
                                    showCustomSnackBar('your_search_box_is_empty'.tr);
                                  }
                                }else if(expenseController.searchMode){
                                  _searchController.text = '';
                                  expenseController.setSearchText(offset: '1', from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to, searchText: _searchController.text);
                                }
                              },
                            ),
                          ),
                          onSubmitted: (value){
                            if(value.isNotEmpty){
                              expenseController.setSearchText(offset: '1', from: Get.find<ExpenseController>().from, to: Get.find<ExpenseController>().to, searchText: value);
                            }else{
                              showCustomSnackBar('your_search_box_is_empty'.tr);
                            }
                          },
                        );
                      }
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => expenseController.showDatePicker(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall + 1),
                    child: Icon(Icons.calendar_today_outlined, color: Theme.of(context).cardColor),
                  ),
                )
              ]),
            ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('from'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
                const SizedBox(width: Dimensions.fontSizeExtraSmall),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                  ),
                  child: Text(DateConverter.convertDateToDate(expenseController.from!), style: robotoMedium),
                ),
                const SizedBox(width: 5),

                Text('to'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
                const SizedBox(width: 5),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                  ),
                  child: Text(DateConverter.convertDateToDate(expenseController.to!), style: robotoMedium),
                ),
              ]),

              Expanded(
                child: expenseController.expenses != null ? expenseController.expenses!.isNotEmpty ? ListView.builder(
                  controller: scrollController,
                  itemCount: expenseController.expenses!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                  return ExpenseCard(expense: expenseController.expenses![index]);
                }) : Center(child: Text('no_expense_found'.tr, style: robotoMedium)) : const Center(child: CircularProgressIndicator()),
              ),

            expenseController.isLoading ? Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            )) : const SizedBox(),
          ]);
        }
      ),
    );
  }
}
