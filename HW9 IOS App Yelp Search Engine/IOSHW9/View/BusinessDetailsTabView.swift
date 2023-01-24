//
//  business_details.swift
//  IOSHW9
//
//  Created by yuhao on 11/16/22.
//

import SwiftUI

struct BusinessDetailsTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject private var bussines: Business
    var body: some View {
        TabView(selection: $selectedTab) {
            BusinessDetailsView()
                .tabItem {
                VStack{
                    Image(systemName: "text.bubble.fill")
                    Text("Business Detail")
                }
            }.tag(1)
            MapView()
                .tabItem {
                    VStack {
                        Image(systemName: "location.fill")
                        Text("Map Location")
                    }
                    
                }.tag(2)
            BussinesReviewView()
                .tabItem {
                    VStack {
                        Image(systemName: "message.fill")
                        Text("Reviews")
                    }
                    
                }.tag(3)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BusinessDetailsTabView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailsTabView()
    }
}
