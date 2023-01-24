//
//  MapView.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import SwiftUI
import MapKit
struct MapView: View {
    
    @EnvironmentObject private var bussines: Business
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude:37.761591,
            longitude:-122.425717
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.005,
            longitudeDelta: 0.005
        )
    )
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [bussines]) { place in
            MapMarker(coordinate: place.coordinates?.coordinates ?? region.center)
        }
        .onAppear{
            withAnimation(.spring()){
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (bussines.coordinates?.latitude ?? 0.0), longitude: (bussines.coordinates?.longitude ?? 0.0)), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            }
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
