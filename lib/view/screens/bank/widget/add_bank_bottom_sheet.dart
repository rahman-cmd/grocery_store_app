import 'package:sixam_mart_store/controller/bank_controller.dart';
import 'package:sixam_mart_store/data/model/body/bank_info_body.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/view/base/custom_button.dart';
import 'package:sixam_mart_store/view/base/custom_snackbar.dart';
import 'package:sixam_mart_store/view/screens/bank/widget/bank_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBankBottomSheet extends StatelessWidget {
  final String? bankName;
  final String? branchName;
  final String? holderName;
  final String? accountNo;
  AddBankBottomSheet({Key? key, this.bankName, this.branchName, this.holderName, this.accountNo}) : super(key: key);

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  final FocusNode _bankNameFocus = FocusNode();
  final FocusNode _branchNameFocus = FocusNode();
  final FocusNode _holderNameFocus = FocusNode();
  final FocusNode _accountNoFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    _bankNameController.text = bankName ?? '';
    _branchNameController.text = branchName ?? '';
    _holderNameController.text = holderName ?? '';
    _accountNoController.text = accountNo ?? '';

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
      ),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [

        InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        BankField(
          hintText: 'bank_name'.tr,
          controller: _bankNameController,
          focusNode: _bankNameFocus,
          nextFocus: _branchNameFocus,
          capitalization: TextCapitalization.words,
        ),

        BankField(
          hintText: 'branch_name'.tr,
          controller: _branchNameController,
          focusNode: _branchNameFocus,
          nextFocus: _holderNameFocus,
          capitalization: TextCapitalization.words,
        ),

        BankField(
          hintText: 'holder_name'.tr,
          controller: _holderNameController,
          focusNode: _holderNameFocus,
          nextFocus: _accountNoFocus,
          capitalization: TextCapitalization.words,
        ),

        BankField(
          hintText: 'account_no'.tr,
          controller: _accountNoController,
          focusNode: _accountNoFocus,
          inputAction: TextInputAction.done,
        ),

        const SizedBox(height: Dimensions.paddingSizeSmall),

        GetBuilder<BankController>(builder: (bankController) {
          return !bankController.isLoading ? CustomButton(
            buttonText: bankName != null ? 'update'.tr : 'add_bank'.tr,
            onPressed: () {
              String bankName = _bankNameController.text.trim();
              String branchName = _branchNameController.text.trim();
              String holderName = _holderNameController.text.trim();
              String accountNo = _accountNoController.text.trim();
              if(bankName == bankName && branchName == branchName && holderName == holderName
                  && accountNo == accountNo) {
                showCustomSnackBar('change_something_to_update'.tr);
              }else if(bankName.isEmpty) {
                showCustomSnackBar('enter_bank_name'.tr);
              }else if(branchName.isEmpty) {
                showCustomSnackBar('enter_branch_name'.tr);
              }else if(holderName.isEmpty) {
                showCustomSnackBar('enter_holder_name'.tr);
              }else if(accountNo.isEmpty) {
                showCustomSnackBar('enter_account_no'.tr);
              }else {
                Get.find<BankController>().updateBankInfo(BankInfoBody(
                  bankName: bankName, branch: branchName, holderName: holderName, accountNo: accountNo,
                ));
              }
            },
          ) : const Center(child: CircularProgressIndicator());
        }),

      ])),
    );
  }
}
