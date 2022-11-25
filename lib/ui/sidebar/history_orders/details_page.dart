import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/helpers/constant.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/receiver.dart';
import 'package:egorka/model/route_order.dart';
import 'package:egorka/model/sender.dart';
import 'package:egorka/ui/newOrder/new_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HistoryDetailsPage extends StatelessWidget {
  int index;
  TypeAdd typeAdd;
  RouteOrder routeOrder;

  HistoryDetailsPage({
    super.key,
    required this.index,
    required this.typeAdd,
    required this.routeOrder,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewOrderPageBloc>(
          create: (context) => NewOrderPageBloc(),
        ),
      ],
      child: DetailsPageTemp(
        index: index,
        typeAdd: typeAdd,
        routeOrder: routeOrder,
      ),
    );
  }
}

class DetailsPageTemp extends StatefulWidget {
  int index;
  TypeAdd typeAdd;
  RouteOrder routeOrder;

  DetailsPageTemp({
    super.key,
    required this.index,
    required this.typeAdd,
    required this.routeOrder,
  });

  static Sender sender = Sender(
    firstName: 'Олег',
    secondName: 'Бочко',
    phone: '+79223747362',
    address: 'г.Москва, ул.Кижеватова д.23',
  );

  static Receiver receiver = Receiver(
    firstName: 'Максим',
    secondName: 'Яковлев',
    phone: '+79111119393',
    address: 'г.Москва, ул.Солнечная д.6',
  );

  @override
  State<DetailsPageTemp> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPageTemp> {
  List<RouteOrder> routeOrderSender = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  List<RouteOrder> routeOrderReceiver = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  TextEditingController controllerTo = TextEditingController();
  TextEditingController controllerPod = TextEditingController();
  TextEditingController controllerEtaj = TextEditingController();
  TextEditingController controllerOffice = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerComment = TextEditingController();

  PanelController panelController = PanelController();

  bool btmSheet = false;
  TypeAdd? typeAdd;

  @override
  void initState() {
    super.initState();
    controllerTo.text = widget.routeOrder.adress;
    controllerPod.text = widget.routeOrder.pod!;
    controllerEtaj.text = widget.routeOrder.etaj!;
    controllerOffice.text = widget.routeOrder.offic!;
    controllerName.text = widget.routeOrder.name!;
    controllerPhone.text = widget.routeOrder.phone!;
    controllerComment.text = widget.routeOrder.comment!;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewOrderPageBloc>(
          create: (context) => NewOrderPageBloc(),
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.5),
          leading: const SizedBox(),
          elevation: 0.5,
          flexibleSpace: Column(
            children: [
              const Spacer(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: 25.h,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    'Назад',
                                    style: CustomTextStyle.red15
                                        .copyWith(fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              child: Text(
                                'Детали',
                                style: CustomTextStyle.black15w500.copyWith(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 20.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 80.w,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: widget.typeAdd == TypeAdd.sender
                              ? Colors.red
                              : Colors.blue,
                          width: 2.w,
                        ),
                      ),
                    ),
                    Text(
                      widget.typeAdd == TypeAdd.sender
                          ? 'А${widget.index}'
                          : 'Б${widget.index}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Text(
                        widget.typeAdd == TypeAdd.sender
                            ? 'Откуда забрать?'
                            : 'Куда отвезти?',
                        style: CustomTextStyle.grey15bold.copyWith(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controllerTo.text,
                          style: CustomTextStyle.grey15bold.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Text(
                              'Подъезд ${controllerPod.text.isNotEmpty ? controllerPod.text : '-'}, ',
                              style: CustomTextStyle.grey15bold,
                            ),
                            Text(
                              'Этаж ${controllerEtaj.text.isNotEmpty ? controllerEtaj.text : '-'}, ',
                              style: CustomTextStyle.grey15bold,
                            ),
                            Text(
                              'Офис/кв. ${controllerOffice.text.isNotEmpty ? controllerOffice.text : '-'}',
                              style: CustomTextStyle.grey15bold,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Text(
                        'Контакты',
                        style: CustomTextStyle.grey15bold.copyWith(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Имя: ',
                                  style: CustomTextStyle.grey15bold
                                      .copyWith(fontWeight: FontWeight.w700)),
                              TextSpan(
                                text: controllerName.text.isNotEmpty
                                    ? controllerName.text
                                    : '-',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Телефон: ',
                                  style: CustomTextStyle.grey15bold
                                      .copyWith(fontWeight: FontWeight.w700)),
                              TextSpan(
                                text: controllerPhone.text.isNotEmpty
                                    ? controllerPhone.text
                                    : '-',
                                style: CustomTextStyle.grey15bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      Text(
                        'Поручения для Егорки',
                        style: CustomTextStyle.grey15bold.copyWith(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      '${controllerComment.text.isNotEmpty ? controllerComment.text : '-'} ',
                      style: CustomTextStyle.grey15bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}