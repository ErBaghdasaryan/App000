//
//  PublicationNavigationModel.swift
//  
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import Foundation
import Combine

public final class PublicationNavigationModel {
    public var user: UserModel
    public var posts: PostItem
    
    public init(user: UserModel, posts: PostItem) {
        self.user = user
        self.posts = posts
    }
}
