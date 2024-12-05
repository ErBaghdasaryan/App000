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
    public let paginationToken: String?
    public let items: [PostItem]
}

// MARK: - Item
public struct PostItem: Codable {
    public let id, mediaType: String
    public let productType: ProductType
    public let isPinned: Bool
    public let carousel: [Carousel]
    public let thumbnail, imageDownloadUrl: String
    public let videoDownloadUrl: String?
    public let requestedUrl: String
}

// MARK: - Carousel
public struct Carousel: Codable {
    public let videoDownloadUrl: JSONNull?
    public let imageDownloadUrl: String
}

public enum ProductType: String, Codable {
    case carouselContainer = "carousel_container"
    case feed = "feed"
    case igtv = "igtv"
}
