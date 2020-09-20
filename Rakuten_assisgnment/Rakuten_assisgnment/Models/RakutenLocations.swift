//
//  RakutenLocations.swift
//  Rakuten_assisgnment
//
//  Created by Balimidi, Rahul on 20/09/20.
//  Copyright © 2020 Balimidi, Rahul. All rights reserved.
//

import Foundation


//  Usage:  let rakutenLocations = try? newJSONDecoder().decode(RakutenLocations.self, from: jsonData)

import Foundation

// MARK: - RakutenLocations
struct RakutenLocations: Codable {
    let metadata: Metadata
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let paging: Paging
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let type: TypeEnum
    let uuid: String
    let properties: Properties
}

// MARK: - Properties
struct Properties: Codable {
    let permalink, apiPath, webPath: String
    let apiURL: String
    let name: String
    let stockExchange, stockSymbol: String?
    let primaryRole: PrimaryRole
    let shortDescription: String
    let profileImageURL: String?
    let domain: String?
    let homepageURL, facebookURL, twitterURL, linkedinURL: String?
    let cityName, regionName, countryCode: String?
    let createdAt, updatedAt: Int

    enum CodingKeys: String, CodingKey {
        case permalink
        case apiPath = "api_path"
        case webPath = "web_path"
        case apiURL = "api_url"
        case name
        case stockExchange = "stock_exchange"
        case stockSymbol = "stock_symbol"
        case primaryRole = "primary_role"
        case shortDescription = "short_description"
        case profileImageURL = "profile_image_url"
        case domain
        case homepageURL = "homepage_url"
        case facebookURL = "facebook_url"
        case twitterURL = "twitter_url"
        case linkedinURL = "linkedin_url"
        case cityName = "city_name"
        case regionName = "region_name"
        case countryCode = "country_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum PrimaryRole: String, Codable {
    case company = "company"
    case investor = "investor"
}

enum TypeEnum: String, Codable {
    case organizationSummary = "OrganizationSummary"
}

// MARK: - Paging
struct Paging: Codable {
    let totalItems, numberOfPages, currentPage: Int
    let sortOrder: String
    let itemsPerPage: Int
    let nextPageURL, prevPageURL, keySetURL: JSONNull?
    let collectionURL: String
    let updatedSince: JSONNull?

    enum CodingKeys: String, CodingKey {
        case totalItems = "total_items"
        case numberOfPages = "number_of_pages"
        case currentPage = "current_page"
        case sortOrder = "sort_order"
        case itemsPerPage = "items_per_page"
        case nextPageURL = "next_page_url"
        case prevPageURL = "prev_page_url"
        case keySetURL = "key_set_url"
        case collectionURL = "collection_url"
        case updatedSince = "updated_since"
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let version: Int
    let wwwPathPrefix, apiPathPrefix: String
    let imagePathPrefix: String

    enum CodingKeys: String, CodingKey {
        case version
        case wwwPathPrefix = "www_path_prefix"
        case apiPathPrefix = "api_path_prefix"
        case imagePathPrefix = "image_path_prefix"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
