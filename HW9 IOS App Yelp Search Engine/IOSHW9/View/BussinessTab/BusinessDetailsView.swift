//
//  BusinessDetailsView.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import SwiftUI
import Kingfisher

struct BusinessDetailsView: View {
    @EnvironmentObject private var bussines: Business
    @EnvironmentObject private var reservation:ReservationViewModel
    @ObservedObject var bussinesDetails = BussinessDetailViewModel()
    
    @State private var showingSheet = false
    @State private var showingReservsationAlert = false
    var body: some View {
        ScrollView(showsIndicators:false) {
            if self.bussinesDetails.isAPICall{
                ProgressView {
                    HStack{
                        Spacer()
                        Text("Please wait....")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }else{
                
                VStack(spacing:20){
                    VStack(spacing:20){
                        Text(self.bussinesDetails.bussines?.name ?? "")
                            .bold()
                            .font(.system(size: 30))
                        HStack{
                            
                            VStack(alignment: .leading){
                                Text("Address")
                                    .bold()
                                Text(self.bussinesDetails.bussines?.location?.getAddress() ?? "")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("Category")
                                    .bold()
                                Text(self.bussinesDetails.bussines?.getCategory() ?? "")
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                        }
                        HStack {
                            
                            VStack(alignment: .leading){
                                Text("Phone")
                                    .multilineTextAlignment(.leading)
                                    .bold()
                                Text(self.bussinesDetails.bussines?.displayPhone ?? "")
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("Price Range")
                                    .bold()
                                Text(self.bussinesDetails.bussines?.price ?? "")
                                    .foregroundColor(.gray)
                                
                            }
                            
                        }
                        HStack {
                            VStack(alignment: .leading){
                                Text("Status")
                                    .bold()
                                if self.bussinesDetails.bussines?.isClosed ?? true{
                                    Text("Closed")
                                        .foregroundColor(.red)
                                }else{
                                    Text("Open Now")
                                        .foregroundColor(.green)
                                }
                            }
                            
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("Visit Yelp for more")
                                    .bold()
                                if let url = URL(string: self.bussinesDetails.bussines?.url ?? ""){
                                    Link("Business Link", destination: url)
                                }
                            }
                        }
                    }
                    if self.reservation.isAnyReservation(id: self.bussinesDetails.bussines?.id ?? ""){
                        Button("Cancel Reservation") {
                            self.reservation.deleteReservation(with: self.bussinesDetails.bussines?.id ?? "")
                            self.showingReservsationAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.showingReservsationAlert = false
                            }
                        }
                        .font(Font.custom("Helvetica Neue", size: 15.0))
                        .padding(15)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(12)
                        
                    }else{
                        Button("Reserve Now") {
                            showingSheet.toggle()
                        }
                        .font(Font.custom("Helvetica Neue", size: 15.0))
                        .padding(15)
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                    
                    
                    HStack{
                        Text("Share on:")
                            .bold()
                        Button(action: {
                            if let url = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(self.bussinesDetails.bussines?.url ?? "")"){
                                UIApplication.shared.open(url,options: [:]){ status in
                                    
                                }
                            }
                        }){
                            ZStack{
                                Image("fb")
                                    .resizable()
                                    .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                    .frame(width: 40,height: 40)
                                
                            }
                        }
                        Button(action: {
                            let strTitle = (self.bussinesDetails.bussines?.name ?? "").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                            if let url = URL(string: "https://twitter.com/intent/tweet?text=\(strTitle)&url=\(self.bussinesDetails.bussines?.url ?? "")"){
                                UIApplication.shared.open(url,options: [:]){ status in
                                    
                                }
                            }
                            
                        }){
                            ZStack{
                                Image("twitter")
                                    .resizable()
                                    .renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                                    .frame(width: 40,height: 40)
                                
                            }
                        }
                    }
                    .padding(.top, 5.0)
                    if (self.bussinesDetails.bussines?.photos?.count ?? 0) > 0{
                        TabView {
                            ForEach(self.bussinesDetails.bussines?.photos ?? [], id: \.self) { item in
                                KFImage(URL(string: item))
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(5)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 250)
                    }
                }.padding()
            }
        }
        .onAppear{
            self.bussinesDetails.fetchBussinessDetailResult(id:self.bussines.id ?? "")
        }
        .sheet(isPresented: $showingSheet) {
            ReservationForm()
        }
        .toast(isShowing: $showingReservsationAlert, text: Text("Your reservation is cancelled"),position: .center)
    }
}

struct BusinessDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailsView()
    }
}
