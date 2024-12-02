//
//  UserModel.swift
//  
//
//  Created by Er Baghdasaryan on 02.12.24.
//
import UIKit

public struct UserModel {
    public let id: Int?
    public let userID: String
    public let name: String
    public let username: String
    public let avatar: UIImage
    public let description: String
    public let totalPublications: Int
    public let totalSubscribers: Int
    public let totalSubscriptions: Int
    public let isSaved: Bool

    public init(id: Int? = nil, userID: String, name: String, username: String, avatar: UIImage, description: String, totalPublications: Int, totalSubscribers: Int, totalSubscriptions: Int, isSaved: Bool) {
        self.id = id
        self.userID = userID
        self.name = name
        self.username = username
        self.avatar = avatar
        self.description = description
        self.totalPublications = totalPublications
        self.totalSubscribers = totalSubscribers
        self.totalSubscriptions = totalSubscriptions
        self.isSaved = isSaved
    }
}
