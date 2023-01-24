//
//  ReservationView.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import SwiftUI

struct ReservationView: View {
    @EnvironmentObject private var reservation:ReservationViewModel
    var body: some View {
        VStack(){
            if self.reservation.reservationList.count == 0{
                Text("No reservations to show")
            }else{
                List{
                    ForEach(self.reservation.reservationList, id: \.u_id) { item in
                        GeometryReader { geometryProxy in
                            VStack(alignment:.leading){
                                HStack{
                                    Text(item.name).frame(width:geometryProxy.size.width*0.3)
                                        .multilineTextAlignment(.leading)
                                    VStack(alignment:.leading){
                                        Text(item.date)
                                        Text(item.time)
                                    }.frame(width:geometryProxy.size.width*0.3)
                                    Text(item.email).frame(width:geometryProxy.size.width*0.4)
                                }
                            }
                            .font(.footnote)
                        }
                    }
                    .onDelete(perform: self.deleteItem)
                }
            }
        }
        .onAppear{
            self.reservation.getAllReservationList()
        }
        .navigationTitle("Your Reservations")
    }
    private func deleteItem(at indexSet: IndexSet) {
        self.reservation.deleteReservation(with: indexSet)
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView()
    }
}
