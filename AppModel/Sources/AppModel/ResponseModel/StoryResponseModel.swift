//
//  StoryResponseModel.swift
//  
//
//  Created by Er Baghdasaryan on 04.12.24.
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
    public let userId, name, username: String
    public let avatar, thumbnail, imageDownloadUrl: String
    public let videoDownloadUrl: String?
    public let publishedAt, sinceStr: String
    public let requestedUrl: String
}
