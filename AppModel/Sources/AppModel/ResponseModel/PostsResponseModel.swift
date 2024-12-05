//
//  PostsResponseModel.swift
//
//
//  Created by Er Baghdasaryan on 04.12.24.
//

import Foundation

// MARK: - Welcome
public struct PostsResponseModel: Codable {
    public let error: Bool
    public let messages: [JSONAny]
    public let data: Posts
}

// MARK: - DataClass
public struct Posts: Codable {
    public let profilePosts: ProfilePosts
}

// MARK: - ProfilePosts
public  struct ProfilePosts: Codable {
    public let count: Int
    public let hasMore: Bool
    public let paginationToken: String
    public let items: [PostItem]
}

// MARK: - Item
public struct PostItem: Codable {
    let id, mediaType: String
    let productType: ProductType
    let isPinned: Bool
    let carousel: [Carousel]
    let thumbnail, imageDownloadURL: String
    let videoDownloadURL: String?
    let requestedURL: String

    enum CodingKeys: String, CodingKey {
        case id, mediaType, productType, isPinned, carousel, thumbnail
        case imageDownloadURL = "imageDownloadUrl"
        case videoDownloadURL = "videoDownloadUrl"
        case requestedURL = "requestedUrl"
    }
}

// MARK: - Carousel
struct Carousel: Codable {
    let videoDownloadURL: JSONNull?
    let imageDownloadURL: String

    enum CodingKeys: String, CodingKey {
        case videoDownloadURL = "videoDownloadUrl"
        case imageDownloadURL = "imageDownloadUrl"
    }
}

enum ProductType: String, Codable {
    case carouselContainer = "carousel_container"
    case feed = "feed"
    case igtv = "igtv"
}
