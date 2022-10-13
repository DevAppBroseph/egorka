part of 'search_bloc.dart';

abstract class SearchAddressState {}

class SearchAddressStated extends SearchAddressState {}

class SearchAddressLoading extends SearchAddressState {}

class SearchAddressSuccess extends SearchAddressState {
  Address? address;

  SearchAddressSuccess(this.address);
}

class SearchAddressFailed extends SearchAddressState {}