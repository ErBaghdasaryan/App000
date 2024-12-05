//
//  HistoryNavigationModel.swift
//  
//
//  Created by Er Baghdasaryan on 04.12.24.
//

import Foundation
import Combine

public final class HistoryNavigationModel {
    public var user: UserModel
    public var stories: [StoryItem]
    
    public init(user: UserModel, stories: [StoryItem]) {
        self.user = user
        self.stories = stories
    }
}
