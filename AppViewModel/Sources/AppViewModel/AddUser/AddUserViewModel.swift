//
//  AddUserViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import Foundation
import AppModel

public protocol IAddUserViewModel {
    var user: UserModel { get set }
}

public class AddUserViewModel: IAddUserViewModel {

    private let homeService: IHomeService
    public var user: UserModel

    public init(homeService: IHomeService, navigationModel: UserNavigationModel) {
        self.homeService = homeService
        self.user = navigationModel.model
    }
}

