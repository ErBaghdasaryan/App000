//
//  StoryModel.swift
//  
//
//  Created by Er Baghdasaryan on 04.12.24.
//

import UIKit

public struct StoryModel {
    public let id, mediaType, productType: String
    public let isPinned: Bool
    public let userId, name, username: String
    public let avatar, thumbnail, imageDownloadUrl: String
    public let videoDownloadUrl: String?
    public let publishedAt, sinceStr: String
    public let requestedUrl: String

    public init(id: String, mediaType: String, productType: String, isPinned: Bool, userId: String, name: String, username: String, avatar: String, thumbnail: String, imageDownloadUrl: String, videoDownloadUrl: String?, publishedAt: String, sinceStr: String, requestedUrl: String) {
        self.id = id
        self.mediaType = mediaType
        self.productType = productType
        self.isPinned = isPinned
        self.userId = userId
        self.name = name
        self.username = username
        self.avatar = avatar
        self.thumbnail = thumbnail
        self.imageDownloadUrl = imageDownloadUrl
        self.videoDownloadUrl = videoDownloadUrl
        self.publishedAt = publishedAt
        self.sinceStr = sinceStr
        self.requestedUrl = requestedUrl
    }
}
