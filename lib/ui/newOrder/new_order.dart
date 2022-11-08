import 'package:egorka/core/bloc/new_order/new_order_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/receiver.dart';
import 'package:egorka/model/route_order.dart';
import 'package:egorka/model/sender.dart';
import 'package:egorka/widget/bottom_sheet_add_adress.dart';
import 'package:egorka/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum TypeAdd { sender, receiver }

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

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
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  List<RouteOrder> routeOrderSender = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  List<RouteOrder> routeOrderReceiver = [
    RouteOrder(adress: 'москва солнечная 6'),
  ];

  TextEditingController fromController = TextEditingController();

  PanelController panelController = PanelController();
  bool btmSheet = false;
  TypeAdd? typeAdd;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewOrderPageBloc>(
          create: (context) => NewOrderPageBloc(),
        ),
      ],
      child: Material(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.5),
            leading: SizedBox(),
            flexibleSpace: Column(
              children: [
                Spacer(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text('Отмена',
                                    style: CustomTextStyle.red15
                                        .copyWith(fontSize: 17)),
                              ),
                              Align(
                                child: Text(
                                  'Оформление заказа',
                                  style: CustomTextStyle.black15w500.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
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
          body: Column(
            children: [
              BlocBuilder<NewOrderPageBloc, NewOrderState>(
                  buildWhen: (previous, current) {
                if (current is NewOrderCloseBtmSheet) {
                  btmSheet = false;
                } else if (current is NewOrderStatedOpenBtmSheet) {
                  btmSheet = true;
                } else if (current is NewOrderStateCloseBtmSheet) {
                  btmSheet = false;
                  if (typeAdd != null && typeAdd == TypeAdd.sender) {
                    routeOrderSender.add(RouteOrder(adress: current.value!));
                  } else if (typeAdd != null && typeAdd == TypeAdd.receiver) {
                    routeOrderReceiver.add(RouteOrder(adress: current.value!));
                  }
                }

                return true;
              }, builder: (context, snapshot) {
                return Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 8),
                                    child: Text(
                                      'Отправитель',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: routeOrderSender.length,
                                    padding: EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/from.png',
                                                  height: 25,
                                                ),
                                                const SizedBox(width: 15),
                                                Flexible(
                                                  child: Text(
                                                    routeOrderSender[index]
                                                        .adress,
                                                    style: CustomTextStyle
                                                        .black15w500
                                                        .copyWith(fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_downward_rounded,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(width: 15),
                                                Text(
                                                  'Указать детали',
                                                  style: CustomTextStyle.red15
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      typeAdd = TypeAdd.sender;
                                      BlocProvider.of<NewOrderPageBloc>(context)
                                          .add(NewOrderOpenBtmSheet());
                                      panelController.animatePanelToPosition(1,
                                          curve: Curves.easeInOutQuint,
                                          duration:
                                              Duration(milliseconds: 1000));
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Text(
                                          'Добавить отправителя',
                                          style: CustomTextStyle.black15w500
                                              .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 8),
                                    child: Text(
                                      'Получатель',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: routeOrderReceiver.length,
                                    padding: EdgeInsets.all(0),
                                    itemBuilder: ((context, index) {
                                      return Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/to.png',
                                                  height: 25,
                                                ),
                                                const SizedBox(width: 15),
                                                Text(
                                                  routeOrderReceiver[index]
                                                      .adress,
                                                  style: CustomTextStyle
                                                      .black15w500
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Icon(
                                                  index ==
                                                          routeOrderReceiver
                                                                  .length -
                                                              1
                                                      ? Icons.flag
                                                      : Icons
                                                          .arrow_downward_rounded,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(width: 15),
                                                Text(
                                                  'Указать детали',
                                                  style: CustomTextStyle.red15
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      typeAdd = TypeAdd.receiver;
                                      BlocProvider.of<NewOrderPageBloc>(context)
                                          .add(NewOrderOpenBtmSheet());
                                      panelController.animatePanelToPosition(1,
                                          curve: Curves.easeInOutQuint,
                                          duration:
                                              Duration(milliseconds: 1000));
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Добавить получателя',
                                          style: CustomTextStyle.black15w500
                                              .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 10, bottom: 8),
                                    child: Text(
                                      'Что везем?',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  
                                  CustomTextField(
                                    height: 50,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    hintStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintText:
                                        'Документы / Цветы / Техника / Личная вещь',
                                    textEditingController:
                                        TextEditingController(),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, top: 10, bottom: 8),
                                    child: Text(
                                      'Ценность вашего груза?',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  CustomTextField(
                                    height: 50,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    hintStyle: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintText: 'До 100000 ₽',
                                    textEditingController:
                                        TextEditingController(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 210)
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  // height: 7,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        'assets/images/ic_leg.png',
                                        color: Colors.red,
                                        height: 80,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Пеший',
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            '1900 ₽',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Center(
                                        child: Text(
                                          '}',
                                          style: TextStyle(
                                            height: 1,
                                            fontSize: 60,
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            '400 ₽ доставка',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 3),
                                          Text('0 ₽ доп. услуги',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(height: 3),
                                          Text('11 ₽ сбор-плат. сист.',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        'ОПЛАТИТЬ ЗАКАЗ',
                                        style: CustomTextStyle.white15w600
                                            .copyWith(
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SlidingUpPanel(
                        controller: panelController,
                        renderPanelSheet: false,
                        isDraggable: true,
                        collapsed: Container(),
                        panel: AddAdressBottomSheetDraggable(
                          typeAdd: typeAdd,
                          fromController: fromController,
                          panelController: panelController,
                        ),
                        onPanelClosed: () {
                          fromController.text = '';
                          // focusFrom.unfocus();
                          // focusTo.unfocus();
                          // _visible = false;
                        },
                        onPanelOpened: () {
                          // _visible = true;
                          // if (!focusFrom.hasFocus && !focusTo.hasFocus) {
                          //   panelController.close();
                          // }
                        },
                        onPanelSlide: (size) {
                          // if (size.toStringAsFixed(1) == (0.5).toString()) {
                          //   focusFrom.unfocus();
                          //   focusTo.unfocus();
                          // }
                        },
                        maxHeight: 700,
                        minHeight: 0,
                        defaultPanelState: PanelState.CLOSED,
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
