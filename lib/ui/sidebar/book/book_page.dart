import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/book.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookPage extends StatelessWidget {
  final book = [
    Book(
      number: 1022,
      adress: 'Москва Ленина 7',
      mark: 'Дом',
    ),
    Book(
      number: 1022,
      adress: 'Москва Нуржанова 18',
      mark: 'Офис',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          'Записная книжка',
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
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Row(
              children: [
                const Text(
                  'Поиск',
                  style: CustomTextStyle.black15w500,
                ),
                const Spacer(),
                CustomTextField(
                  hintText: 'По ключевым словам',
                  textEditingController: TextEditingController(),
                  textInputType: TextInputType.number,
                  width: 250.w,
                  fillColor: Colors.white,
                  height: 50.h,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  formatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50.w,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: book.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: 50.h,
                      color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                      child: Row(
                        children: [
                          SizedBox(width: 10.w),
                          const Expanded(flex: 2, child: Text('№')),
                          SizedBox(width: 10.w),
                          const Expanded(flex: 4, child: Text('Адрес')),
                          const Expanded(flex: 3, child: Text('Обозначение')),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    );
                  }
                  return Container(
                    height: 50.h,
                    color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                    child: Row(
                      children: [
                        SizedBox(width: 10.w),
                        Expanded(
                            flex: 2, child: Text('${book[index - 1].number}')),
                        Expanded(flex: 4, child: Text(book[index - 1].adress)),
                        Expanded(flex: 3, child: Text(book[index - 1].mark)),
                        SizedBox(width: 10.w),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
