//
//  StoryArchive.swift
//  
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import UIKit

public struct StoryArchive {
    public let id: Int?
    public let userId: String
    public let url: String
    public let videoDownloadUrl: String?
    public let thumbnail: String

    public init(id: Int? = nil, userId: String, url: String, videoDownloadUrl: String?, thumbnail: String) {
        self.id = id
        self.userId = userId
        self.url = url
        self.videoDownloadUrl = videoDownloadUrl
        self.thumbnail = thumbnail
    }
}
