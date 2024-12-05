//
//  PublicationArchive.swift
//
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import UIKit

public struct PublicationArchive {
    public let id: Int?
    public let userId: String
    public let url: String

    public init(id: Int?, userId: String, url: String) {
        self.id = id
        self.userId = userId
        self.url = url
    }
}
