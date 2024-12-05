//
//  ArchiveViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import Foundation
import AppModel

public protocol IArchiveViewModel {
    var user: UserModel { get set }
    func getStoryArchives(by userID: String)
    func getPublicationsArchives(by userID: String)
    var storyArchives: [StoryArchive] { get set }
    var publicationsArchives: [PublicationArchive] { get set }
}

public class ArchiveViewModel: IArchiveViewModel {

    private let homeService: IHomeService
    public var user: UserModel
    public var storyArchives: [StoryArchive] = []
    public var publicationsArchives: [PublicationArchive] = []

    public init(homeService: IHomeService, navigationModel: UserNavigationModel) {
        self.homeService = homeService
        self.user = navigationModel.model
    }

    public func getStoryArchives(by userID: String) {
        do {
            storyArchives = try self.homeService.getStoryArchives(forUserID: userID)
        } catch {
            print(error)
        }
    }

    public func getPublicationsArchives(by userID: String) {
        do {
            publicationsArchives = try self.homeService.getPublicationArchives(forUserID: userID)
        } catch {
            print(error)
        }
    }
}
