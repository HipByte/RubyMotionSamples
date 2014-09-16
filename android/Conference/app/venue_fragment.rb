class VenueFragment < Android::App::Fragment
  def onCreateView(inflater, container, savedInstanceState)
    @mapView = begin
      # Initializes the Google Maps API.
      Com::Google::Android::Gms::Maps::MapsInitializer.initialize(activity)

      # Create the map view. The #onCreate call is necessary to initialize the view.
      mapView = Com::Google::Android::Gms::Maps::MapView.new(activity)
      mapView.onCreate(savedInstanceState)

      # Make sure the map can access to the user's current location.
      map = mapView.getMap
      map.uiSettings.myLocationButtonEnabled = false
      map.myLocationEnabled = true

      # Center/zoom the map around Fort Mason.
      coord = Com::Google::Android::Gms::Maps::Model::LatLng.new(37.807778, -122.429722)
      cameraUpdate = Com::Google::Android::Gms::Maps::CameraUpdateFactory.newLatLngZoom(coord, 15.0)
      map.animateCamera(cameraUpdate)

      # Add a location marker for Fort Mason and show it.
      markerOptions = Com::Google::Android::Gms::Maps::Model::MarkerOptions.new
      markerOptions.position(coord)
      markerOptions.title("#inspect 2014")
      marker = map.addMarker(markerOptions)
      marker.showInfoWindow

      mapView
    end
  end

  # These calls are necessary to forward fragment events to the Map View.

  def onResume
    super
    @mapView.onResume
  end

  def onDestroy
    super
    @mapView.onDestroy
  end

  def onLowMemory
    super
    @mapView.onLowMemory
  end
end
