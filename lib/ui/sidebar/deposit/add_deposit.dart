import 'dart:async';
import 'package:egorka/core/bloc/deposit/deposit_bloc.dart';
import 'package:egorka/core/network/repository.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/invoice.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:egorka/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
// import 'package:tinkoff_sdk/tinkoff_sdk.dart';

class AddDeposit extends StatelessWidget {
  InvoiceModel? depositHistory;

  TextEditingController controllerAmount = TextEditingController();
  final streamController = StreamController<List<InvoiceModel>>();

  @override
  Widget build(BuildContext context) {
    final blocInvoice = BlocProvider.of<DepositBloc>(context).invoiceModel;
    if (blocInvoice != null) depositHistory = blocInvoice;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          'Пополнение депозита',
          style: CustomTextStyle.black15w500,
        ),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            const Text(
              'Укажите сумму пополнения:',
              style: CustomTextStyle.black15w500,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                CustomTextField(
                  hintText: '15 000',
                  textEditingController: controllerAmount,
                  textInputType: TextInputType.number,
                  width: 150.w,
                  fillColor: Colors.white,
                  height: 45.h,
                  focusNode: FocusNode(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  formatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                ),
                SizedBox(width: 15.w),
                const Text('руб'),
                const Spacer(),
                // GestureDetector(
                //   onTap: () async {
                //     const _TERMINAL_KEY = 'TERMINAL_KEY';
                //     const _PASSWORD = 'PASSWORD';
                //     const _PUBLIC_KEY = 'PUBLIC_KEY';

                //     final TinkoffSdk acquiring = TinkoffSdk();

                //     await acquiring.activate(
                //         terminalKey: _TERMINAL_KEY,
                //         password: _PASSWORD,
                //         publicKey: _PUBLIC_KEY,
                //         logging: true,
                //         isDeveloperMode: true);
                //     final resultPaymentSuccessful =
                //         await TinkoffSdk().openPaymentScreen(
                //       orderOptions: const OrderOptions(
                //           orderId: '1',
                //           amount: 10000,
                //           title: "Название платежа",
                //           description: "Описание платежа",
                //           saveAsParent: false),
                //       customerOptions: const CustomerOptions(
                //           customerKey: "CUSTOMER_KEY",
                //           email: "email@example.com",
                //           checkType: CheckType.no),
                //       featuresOptions: const FeaturesOptions(
                //         useSecureKeyboard: true,
                //         enableCameraCardScanner: false,
                //       ),
                //     );
                //   },
                //   child: Container(
                //     height: 45.h,
                //     width: 60.w,
                //     decoration: BoxDecoration(
                //       color: Colors.red,
                //       borderRadius: BorderRadius.circular(15.r),
                //     ),
                //     child: Center(
                //       child: Text(
                //         'TinkOFF',
                //         style:
                //             CustomTextStyle.white15w600.copyWith(fontSize: 12),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(width: 5.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () async {
                    if (controllerAmount.text.isEmpty) {
                      MessageDialogs()
                          .showAlert('Ошибка', 'Введите сумму пополнения');
                    } else {
                      MessageDialogs()
                          .showLoadDialog('Формирование депозита...');
                      final res = await Repository()
                          .createInvoice(int.parse(controllerAmount.text));
                      if (res != null) {
                        BlocProvider.of<DepositBloc>(context)
                            .add(CreateDeposotEvent(res));
                        depositHistory = res;
                        streamController.add([res]);
                      }
                      SmartDialog.dismiss();
                    }
                  },
                  child: Center(
                    child: Text(
                      'CФОРМИРОВАТЬ',
                      style: CustomTextStyle.white15w600.copyWith(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'Ранее выставленные счета',
              style: CustomTextStyle.black15w700.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: StreamBuilder<List<InvoiceModel>>(
                  stream: streamController.stream,
                  initialData: [],
                  builder: (context, snapshot) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                            height: 50.h,
                            color: index % 2 == 0
                                ? Colors.white
                                : Colors.grey[200],
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                const Expanded(flex: 2, child: Text('№')),
                                SizedBox(width: 10.w),
                                const Expanded(
                                    flex: 4, child: Text('Дата выставления')),
                                const Expanded(flex: 3, child: Text('Сумма')),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          );
                        }
                        return Container(
                          color:
                              index % 2 == 0 ? Colors.white : Colors.grey[200],
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  SizedBox(width: 10.w),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          '${depositHistory!.result!.invoice!.date}')),
                                  Expanded(
                                      flex: 4,
                                      child: Text(DateFormat.yMMMMd('ru')
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  depositHistory!.result!
                                                          .invoice!.date! *
                                                      1000)))),
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                          '${depositHistory!.result!.invoice!.amount} руб.')),
                                  SizedBox(width: 10.w),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 10.w),
                                  TextButton(
                                    onPressed: () async {
                                      MessageDialogs().showLoadDialog(
                                          'Скачивание и открытие...');
                                      String pdf = await Repository().getPDF(
                                          depositHistory!.result!.invoice!.iD!,
                                          depositHistory!
                                              .result!.invoice!.pIN!);
                                      await OpenFile.open(pdf);
                                      SmartDialog.dismiss();
                                    },
                                    child: const Text(
                                      'Скачать PDF',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  TextButton(
                                    onPressed: () async {
                                      MessageDialogs().showLoadDialog(
                                          'Скачивание и открытие...');
                                      String excel = await Repository()
                                          .getEXCEL(
                                              depositHistory!
                                                  .result!.invoice!.iD!,
                                              depositHistory!
                                                  .result!.invoice!.pIN!);
                                      await OpenFile.open(excel);
                                      SmartDialog.dismiss();
                                    },
                                    child: const Text(
                                      'Скачать EXCEL',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 71, 170, 74)),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
