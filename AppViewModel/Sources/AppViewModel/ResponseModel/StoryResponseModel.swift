//
//  StoryResponseModel.swift
//
//
//  Created by Er Baghdasaryan on 03.12.24.
//

import Foundation

// MARK: - Welcome
public struct StoryResponseModel: Codable {
    public let error: Bool
    public let messages: [JSONAny]
    public let data: Stories
}

// MARK: - DataClass
public struct Stories: Codable {
    public let profileStories: ProfileStories
}

// MARK: - ProfileStories
public struct ProfileStories: Codable {
    public let items: [StoryItem]
}

// MARK: - Item
public struct StoryItem: Codable {
    public let id, mediaType, productType: String
    public let isPinned: Bool
    public let userID, name, username: String
    public let avatar, thumbnail, imageDownloadURL: String
    public let videoDownloadURL: String
    public let publishedAt, sinceStr: String
    public let requestedURL: String

    enum CodingKeys: String, CodingKey {
        case id, mediaType, productType, isPinned
        case userID = "userId"
        case name, username, avatar, thumbnail
        case imageDownloadURL = "imageDownloadUrl"
        case videoDownloadURL = "videoDownloadUrl"
        case publishedAt, sinceStr
        case requestedURL = "requestedUrl"
    }
}
