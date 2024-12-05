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
    func addStoryArchive(_ model: StoryArchive) throws -> StoryArchive
    func deleteStoryArchive(by id: Int) throws
    func getStoryArchives(forUserID userID: String) throws -> [StoryArchive]
    func addPublicationArchive(_ model: PublicationArchive) throws -> PublicationArchive
    func deletePublicationArchive(by id: Int) throws
    func getPublicationArchives(forUserID userID: String) throws -> [PublicationArchive]
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

    public func addStoryArchive(_ model: StoryArchive) throws -> StoryArchive {
        let db = try Connection("\(path)/db.sqlite3")
        let storyArchives = Table("StoryArchives")
        let idColumn = Expression<Int>("id")
        let userIdColumn = Expression<String>("userId")
        let urlColumn = Expression<String>("url")
        let videoDownloadUrlColumn = Expression<String?>("url")
        let thumbnailColumn = Expression<String?>("thumbnail")

        try db.run(storyArchives.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(userIdColumn)
            t.column(urlColumn)
            t.column(videoDownloadUrlColumn)
            t.column(thumbnailColumn)
        })

        let rowId = try db.run(storyArchives.insert(
            userIdColumn <- model.userId,
            urlColumn <- model.url,
            videoDownloadUrlColumn <- model.videoDownloadUrl,
            thumbnailColumn <- model.thumbnail
        ))

        return StoryArchive(id: Int(rowId),
                            userId: model.userId,
                            url: model.url,
                            videoDownloadUrl: model.videoDownloadUrl,
                            thumbnail: model.thumbnail)
    }

    public func getStoryArchives(forUserID userID: String) throws -> [StoryArchive] {
        let db = try Connection("\(path)/db.sqlite3")
        let storyArchives = Table("StoryArchives")
        let idColumn = Expression<Int>("id")
        let userIdColumn = Expression<String>("userId")
        let urlColumn = Expression<String>("url")
        let videoDownloadUrlColumn = Expression<String?>("url")
        let thumbnailColumn = Expression<String>("thumbnail")

        var result: [StoryArchive] = []

        for storyArchive in try db.prepare(storyArchives.filter(userIdColumn == userID)) {

            var fetchedStoryArchive: StoryArchive
            fetchedStoryArchive = StoryArchive(id: storyArchive[idColumn],
                                               userId: storyArchive[userIdColumn],
                                               url: storyArchive[urlColumn],
                                               videoDownloadUrl: storyArchive[videoDownloadUrlColumn],
                                               thumbnail: storyArchive[thumbnailColumn])
            result.append(fetchedStoryArchive)
        }

        return result
    }

    public func deleteStoryArchive(by id: Int) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let storyArchives = Table("StoryArchives")
        let idColumn = Expression<Int>("id")

        let storyArchiveToDelete = storyArchives.filter(idColumn == id)
        try db.run(storyArchiveToDelete.delete())
    }

    public func addPublicationArchive(_ model: PublicationArchive) throws -> PublicationArchive {
        let db = try Connection("\(path)/db.sqlite3")
        let publicationArchives = Table("PublicationArchives")
        let idColumn = Expression<Int>("id")
        let userIdColumn = Expression<String>("userId")
        let urlColumn = Expression<String>("url")

        try db.run(publicationArchives.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(userIdColumn)
            t.column(urlColumn)
        })

        let rowId = try db.run(publicationArchives.insert(
            userIdColumn <- model.userId,
            urlColumn <- model.url
        ))

        return PublicationArchive(id: Int(rowId),
                                  userId: model.userId,
                                  url: model.url)
    }

    public func getPublicationArchives(forUserID userID: String) throws -> [PublicationArchive] {
        let db = try Connection("\(path)/db.sqlite3")
        let publicationArchives = Table("PublicationArchives")
        let idColumn = Expression<Int>("id")
        let userIdColumn = Expression<String>("userId")
        let urlColumn = Expression<String>("url")

        var result: [PublicationArchive] = []

        for publicationArchive in try db.prepare(publicationArchives.filter(userIdColumn == userID)) {

            var fetchedPublicationArchive: PublicationArchive
            fetchedPublicationArchive = PublicationArchive(id: publicationArchive[idColumn],
                                               userId: publicationArchive[userIdColumn],
                                               url: publicationArchive[urlColumn])
            result.append(fetchedPublicationArchive)
        }

        return result
    }

    public func deletePublicationArchive(by id: Int) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let publicationArchives = Table("PublicationArchives")
        let idColumn = Expression<Int>("id")

        let publicationArchiveToDelete = publicationArchives.filter(idColumn == id)
        try db.run(publicationArchiveToDelete.delete())
    }
}
