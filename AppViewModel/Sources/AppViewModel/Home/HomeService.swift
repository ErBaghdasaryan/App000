//
//  HomeService.swift
//  
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppModel
import SQLite

public protocol IHomeService {
    func addUser(_ model: UserModel) throws -> UserModel
    func getUsers() throws -> [UserModel]
    func deleteUser(byID id: Int) throws
    func editUser(_ user: UserModel) throws
}

public class HomeService: IHomeService {

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    public init() { }

    public func addUser(_ model: UserModel) throws -> UserModel {
        let db = try Connection("\(path)/db.sqlite3")
        let users = Table("Users")
        let idColumn = Expression<Int>("id")
        let userIDColumn = Expression<String>("userID")
        let nameColumn = Expression<String>("name")
        let usernameColumn = Expression<String>("username")
        let avatarColumn = Expression<Data>("avatar")
        let descriptionColumn = Expression<String>("description")
        let totalPublicationsColumn = Expression<Int>("totalPublications")
        let totalSubscribersColumn = Expression<Int>("totalSubscribers")
        let totalSubscriptionsColumn = Expression<Int>("totalSubscriptions")
        let requestedURLColumn = Expression<String>("requestedURL")
        let isSavedColumn = Expression<Bool>("isSaved")

        try db.run(users.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(userIDColumn)
            t.column(nameColumn)
            t.column(usernameColumn)
            t.column(avatarColumn)
            t.column(descriptionColumn)
            t.column(totalPublicationsColumn)
            t.column(totalSubscribersColumn)
            t.column(totalSubscriptionsColumn)
            t.column(requestedURLColumn)
            t.column(isSavedColumn)
        })

        guard let imageData = model.avatar.pngData() else {
            throw NSError(domain: "ImageConversionError", code: 1, userInfo: nil)
        }

        let rowId = try db.run(users.insert(
            userIDColumn <- model.userID,
            nameColumn <- model.name,
            usernameColumn <- model.username,
            avatarColumn <- imageData,
            descriptionColumn <- model.description,
            totalPublicationsColumn <- model.totalPublications,
            totalSubscribersColumn <- model.totalSubscribers,
            totalSubscriptionsColumn <- model.totalSubscriptions,
            requestedURLColumn <- model.requestedURL,
            isSavedColumn <- model.isSaved
        ))

        return UserModel(id: Int(rowId),
                         userID: model.userID,
                         name: model.name,
                         username: model.username,
                         avatar: model.avatar,
                         description: model.description,
                         totalPublications: model.totalPublications,
                         totalSubscribers: model.totalSubscribers,
                         totalSubscriptions: model.totalSubscriptions,
                         requestedURL: model.requestedURL,
                         isSaved: model.isSaved)
    }

    public func getUsers() throws -> [UserModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let users = Table("Users")
        let idColumn = Expression<Int>("id")
        let userIDColumn = Expression<String>("userID")
        let nameColumn = Expression<String>("name")
        let usernameColumn = Expression<String>("username")
        let avatarColumn = Expression<Data>("avatar")
        let descriptionColumn = Expression<String>("description")
        let totalPublicationsColumn = Expression<Int>("totalPublications")
        let totalSubscribersColumn = Expression<Int>("totalSubscribers")
        let totalSubscriptionsColumn = Expression<Int>("totalSubscriptions")
        let requestedURLColumn = Expression<String>("requestedURL")
        let isSavedColumn = Expression<Bool>("isSaved")

        var result: [UserModel] = []

        for user in try db.prepare(users) {
            guard let image = UIImage(data: user[avatarColumn]) else {
                throw NSError(domain: "ImageConversionError", code: 2, userInfo: nil)
            }
            let fetchedUser = UserModel(
                id: user[idColumn],
                userID: user[userIDColumn],
                name: user[nameColumn],
                username: user[usernameColumn],
                avatar: image,
                description: user[descriptionColumn],
                totalPublications: user[totalPublicationsColumn],
                totalSubscribers: user[totalSubscribersColumn],
                totalSubscriptions: user[totalSubscriptionsColumn],
                requestedURL: user[requestedURLColumn],
                isSaved: user[isSavedColumn]
            )

            result.append(fetchedUser)
        }

        return result
    }

    public func deleteUser(byID id: Int) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let users = Table("Users")
        let idColumn = Expression<Int>("id")

        let userToDelete = users.filter(idColumn == id)
        try db.run(userToDelete.delete())
    }

    public func editUser(_ user: UserModel) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let users = Table("Users")
        let idColumn = Expression<Int>("id")
        let userIDColumn = Expression<String>("userID")
        let nameColumn = Expression<String>("name")
        let usernameColumn = Expression<String>("username")
        let avatarColumn = Expression<Data>("avatar")
        let descriptionColumn = Expression<String>("description")
        let totalPublicationsColumn = Expression<Int>("totalPublications")
        let totalSubscribersColumn = Expression<Int>("totalSubscribers")
        let totalSubscriptionsColumn = Expression<Int>("totalSubscriptions")
        let requestedURLColumn = Expression<String>("requestedURL")
        let isSavedColumn = Expression<Bool>("isSaved")

        let userToUpdate = users.filter(userIDColumn == user.userID)
        guard let imageData = user.avatar.pngData() else {
            throw NSError(domain: "ImageConversionError", code: 1, userInfo: nil)
        }

        try db.run(userToUpdate.update(
            userIDColumn <- user.userID,
            nameColumn <- user.name,
            usernameColumn <- user.username,
            avatarColumn <- imageData,
            descriptionColumn <- user.description,
            totalPublicationsColumn <- user.totalPublications,
            totalSubscribersColumn <- user.totalSubscribers,
            totalSubscriptionsColumn <- user.totalSubscriptions,
            requestedURLColumn <- user.requestedURL,
            isSavedColumn <- user.isSaved
        ))
    }
}
