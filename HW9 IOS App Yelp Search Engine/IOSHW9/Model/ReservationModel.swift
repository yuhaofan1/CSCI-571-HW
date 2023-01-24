//
//  ReservationModel.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 26/11/22.
//

import Foundation

struct ReservationModel: Codable {
    var u_id: UUID = UUID()
    var id: String = ""
    var name: String = ""
    var date: String = ""
    var time: String = ""
    var email: String = ""
}
