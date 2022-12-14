import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/model/directions.dart';
import 'package:egorka/model/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final VoidCallback callBack;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.160161, 24.468712),
    zoom: 5,
  );
  const MapView({Key? key, required this.callBack}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition? pos;
  Marker? firstMarker;
  Marker? secondMarker;
  Position? position;
  GoogleMapController? mapController;

  Directions? routes;
  Set<Marker> marker = {};

  @override
  void initState() {
    LocationGeo().checkPermission;

    super.initState();
  }

  void _getPosition() async {
    if (await LocationGeo().checkPermission()) {
      // BlocProvider.of<SearchAddressBloc>(context).add(GetAddressPosition());
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mapController != null) {
        await mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 20,
              tilt: 0,
            ),
          ),
        );
      }
    }
    widget.callBack();
  }

  void _findMe() async {
    if (await LocationGeo().checkPermission()) {
      BlocProvider.of<SearchAddressBloc>(context).add(GetAddressPosition());
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 20,
              tilt: 0,
            ),
          ),
        );
        widget.callBack();
      }
    }
  }

  void _jumpToPoint(Point point) async {
    if (await LocationGeo().checkPermission()) {
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(point.latitude!, point.longitude!),
              zoom: 20,
              tilt: 0,
            ),
          ),
        );
        widget.callBack();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<SearchAddressBloc, SearchAddressState>(
          buildWhen: (previous, current) {
        if (current is SearchAddressRoutePolilyne) {
          if (current.coasts.isNotEmpty) {
            routes = current.routes;
            marker = current.markers;
            mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(routes!.bounds, 130.w),
            );
          }
    
          return true;
        } else if (current is FindMeState) {
          _findMe();
          return true;
        } else if (current is DeletePolilyneState) {
          marker = {};
          routes = null;
          return true;
        } else if (current is JumpToPointState) {
          _jumpToPoint(current.point);
          return true;
        }
        if (current is GetAddressSuccess) {
          _jumpToPoint(
              Point(latitude: current.latitude, longitude: current.longitude));
          // BlocProvider.of<SearchAddressBloc>(context).add(
          //   JumpToPointEvent(
          //     Point(
          //         latitude: current.geoData!.latitude,
          //         longitude: current.geoData!.longitude),
          //   ),
          // );
          return true;
        } else {
          return false;
        }
      }, builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: 170.h),
          child: GoogleMap(
            markers: marker,
            polylines: {
              if (routes != null)
                Polyline(
                  polylineId: const PolylineId('route'),
                  visible: true,
                  width: 5,
                  points: routes != null
                      ? routes!.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList()
                      : [],
                  color: const Color.fromARGB(255, 56, 197, 61),
                )
            },
            padding: EdgeInsets.zero,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: (position) {
              pos = position;
            },
            onCameraIdle: () {
              if (pos != null) {
                BlocProvider.of<SearchAddressBloc>(context)
                    .add(ChangeMapPosition(pos!.target));
              }
              if (state is SearchAddressRoutePolilyne) {
                if (routes != null) {
                  mapController!.animateCamera(
                    CameraUpdate.newLatLngBounds(routes!.bounds, 130.w),
                  );
                }
              }
            },
            initialCameraPosition: MapView._kGooglePlex,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              _getPosition();
            },
          ),
        );
      }),
    );
  }
}
