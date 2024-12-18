//
//  HistoryViewModel.swift
//
//
//  Created by Er Baghdasaryan on 04.12.24.
//

import Foundation
import AppModel

public protocol IHistoryViewModel {
    var user: UserModel { get set }
    var stories: [StoryItem] { get set }
    func addStoryArchive(model: StoryArchive)
}

public class HistoryViewModel: IHistoryViewModel {

    private let homeService: IHomeService
    public var user: UserModel
    public var stories: [StoryItem]

    public init(homeService: IHomeService, navigationModel: HistoryNavigationModel) {
        self.homeService = homeService
        self.user = navigationModel.user
        self.stories = navigationModel.stories
    }

    public func addStoryArchive(model: StoryArchive) {
        do {
            _ = try self.homeService.addStoryArchive(model)
        } catch {
            print(error)
        }
    }
}
