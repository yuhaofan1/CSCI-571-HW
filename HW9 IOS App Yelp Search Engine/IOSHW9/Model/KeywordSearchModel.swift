//
//  KeywordSearchModel.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import Foundation
// MARK: - KeywordSearchModel
struct KeywordSearchModel: Codable {
    var categories: [Category]?
    var businesses: [String]?
    var terms: [Term]?
}

// MARK: - Category
struct Category: Codable{
    let alias, title: String?
}

// MARK: - Term
struct Term: Codable {
    let text: String?
}
