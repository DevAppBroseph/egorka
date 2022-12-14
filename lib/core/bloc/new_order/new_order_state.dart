part of 'new_order_bloc.dart';

abstract class NewOrderState {}

class NewOrderStated extends NewOrderState {}

class NewOrderStatedOpenBtmSheet extends NewOrderState {}

class NewOrderCloseBtmSheet extends NewOrderState {}

class CalcLoading extends NewOrderState {}

class CalcSuccess extends NewOrderState {
  CoastResponse? coasts;

  CalcSuccess(this.coasts);
}

class NewOrderStateCloseBtmSheet extends NewOrderState {
  Suggestions? value;

  NewOrderStateCloseBtmSheet(this.value);
}

class NewOrderLoading extends NewOrderState {}

class NewOrderSuccess extends NewOrderState {
  Address? address;

  NewOrderSuccess(this.address);
}

class NewOrderFailed extends NewOrderState {}

class CreateFormState extends NewOrderState {}

class CreateFormSuccess extends NewOrderState {
  CreateFormModel createFormModel;

  CreateFormSuccess(this.createFormModel);
}

class CreateFormFail extends NewOrderState {}

class UpdateState extends NewOrderState {}
