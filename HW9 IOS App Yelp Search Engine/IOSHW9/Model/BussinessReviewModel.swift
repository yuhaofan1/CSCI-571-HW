//
//  BussinessReviewModel.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import Foundation

// MARK: - BussinessReviewModel
struct BussinessReviewModel: Codable {
    let reviews: [Review]?
    let total: Int?
    let possibleLanguages: [String]?

    enum CodingKeys: String, CodingKey {
        case reviews, total
        case possibleLanguages = "possible_languages"
    }
}

// MARK: - Review
struct Review: Codable,Identifiable {
    let id: String?
    let url: String?
    let text: String?
    let rating: Int?
    let timeCreated: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, url, text, rating
        case timeCreated = "time_created"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let id: String?
    let profileURL: String?
    let imageURL: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case profileURL = "profile_url"
        case imageURL = "image_url"
        case name
    }
}

