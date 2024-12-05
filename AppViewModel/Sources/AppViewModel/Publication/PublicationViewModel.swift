//
//  PublicationViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import Foundation
import AppModel

public protocol IPublicationViewModel {
    var user: UserModel { get set }
    var posts: PostItem { get set }
}

public class PublicationViewModel: IPublicationViewModel {

    private let homeService: IHomeService
    public var user: UserModel
    public var posts: PostItem

    public init(homeService: IHomeService, navigationModel: PublicationNavigationModel) {
        self.homeService = homeService
        self.user = navigationModel.user
        self.posts = navigationModel.posts
    }
}
