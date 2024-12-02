//
//  SendModel.swift
//
//
//  Created by Er Baghdasaryan on 28.11.24.
//

import Foundation

public struct SendModel: Codable {
    public let url: String

    public init(url: String) {
        self.url = url
    }
}

