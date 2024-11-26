//
//  HomeViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import AppModel

public protocol IHomeViewModel {

}

public class HomeViewModel: IHomeViewModel {

    private let homeService: IHomeService

    public init(homeService: IHomeService) {
        self.homeService = homeService
    }
}
