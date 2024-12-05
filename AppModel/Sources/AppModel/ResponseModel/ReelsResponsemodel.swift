//
//  ReelsResponsemodel.swift
//  
//
//  Created by Er Baghdasaryan on 04.12.24.
//
import Foundation

// MARK: - ReelResponseModel
public struct ReelResponseModel: Codable {
    public let error: Bool
    public let messages: [JSONAny]
    public let data: Reels
}

// MARK: - DataClass
public struct Reels: Codable {
    public let profileReels: ProfileReels
}

// MARK: - ProfileReels
public struct ProfileReels: Codable {
    public let count: Int
    public let hasMore: Bool
    public let paginationToken: JSONNull?
    public let items: [ReelItem]
}

// MARK: - Item
public struct ReelItem: Codable {
    public let mediaType, productType: String
    public let isPinned: Bool
    public let carousel: [JSONAny]
    public let thumbnail, imageDownloadURL: String
    public let videoDownloadURL: String
    public let requestedURL: String

    public enum CodingKeys: String, CodingKey {
        case mediaType, productType, isPinned, carousel, thumbnail
        case imageDownloadURL = "imageDownloadUrl"
        case videoDownloadURL = "videoDownloadUrl"
        case requestedURL = "requestedUrl"
    }
}
