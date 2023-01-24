//
//  ReservationViewModel.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 26/11/22.
//

import Foundation
import SwiftUI

class ReservationViewModel: ObservableObject{
    @Published var reservationList:[ReservationModel] = []
    
    func getAllReservationList(){
        if let modelData = UserDefaults.standard.object(forKey: "reservationList") as? Data {
            let decoder = JSONDecoder()
            self.reservationList = try! decoder.decode([ReservationModel]?.self, from: modelData) ?? []
        }
    }
    func addNewReservation(id:String,name:String,date:Date,time:String,email:String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: date)
        let model = ReservationModel(id: id,name: name,date:date,time:time,email:email)
        self.getAllReservationList()
        self.reservationList.append(model)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.reservationList) {
            UserDefaults.standard.set(encoded, forKey: "reservationList")
        }
    }
    func deleteReservation(with index:IndexSet){
        self.reservationList.remove(atOffsets: index)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.reservationList) {
            UserDefaults.standard.set(encoded, forKey: "reservationList")
        }
    }
    func deleteReservation(with id:String){
        if let index = self.reservationList.firstIndex(where: { model in
            return model.id == id
        }){
            self.reservationList.remove(at: index)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.reservationList) {
                UserDefaults.standard.set(encoded, forKey: "reservationList")
            }
        }
    }
    func isAnyReservation(id:String)->Bool{
//        self.getAllReservationList()
        return (self.reservationList.first(where: { t in return id == t.id }) != nil)
    }
}
