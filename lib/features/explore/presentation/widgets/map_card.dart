import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapCard extends StatefulWidget {
  final double height;
  final double compassHeading;
  final VoidCallback onLocation;
  final VoidCallback onResetOrientation;

  const MapCard({
    super.key,
    required this.height,
    required this.compassHeading,
    required this.onLocation,
    required this.onResetOrientation,
  });

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  MapboxMap? _mapboxMap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
      height: widget.height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: MapWidget(
          key: const ValueKey("mapWidget"),
          styleUri: MapboxStyles.MAPBOX_STREETS,
          cameraOptions: CameraOptions(
            center: Point(coordinates: Position(-98.0, 39.5)),
            zoom: 2.0,
            bearing: 0.0,
            pitch: 0.0,
          ),
          onMapCreated: (MapboxMap mapboxMap) {
            setState(() {
              _mapboxMap = mapboxMap;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapboxMap?.dispose();
    super.dispose();
  }
}
