//
//  BussinessDetailsModel.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import Foundation

// MARK: - BusinessModel
struct BusinessModel: Codable {
    var businesses: [Business] = []
    let total: Int?
    let region: Region?
}

// MARK: - Business
class Business: Codable,Identifiable,ObservableObject {
    let id, alias, name: String?
    let imageURL: String?
    let isClosed: Bool?
    let url: String?
    let reviewCount: Int?
    let categories: [Category]?
    let rating: Double?
    let coordinates: Coordinates?
    let transactions: [String]?
    let price: String?
    let location: LocationDetail?
    let phone, displayPhone: String?
    let distance: Double?
    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, transactions, price, location, phone
        case displayPhone = "display_phone"
        case distance
    }
}

// MARK: - Location
struct LocationDetail: Codable {
    let address1: String?
    let address2, address3: String?
    let city: String?
    let zipCode: String?
    let country: String?
    let state: String?
    let displayAddress: [String]?

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
    func getAddress()->String{
        return displayAddress?.joined(separator: ", ") ?? ""
    }
}

// MARK: - Region
struct Region: Codable {
    let center: Coordinates?
}
