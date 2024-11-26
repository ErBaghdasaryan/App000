//
//  SettingsViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import AppModel

public protocol ISettingsViewModel {

}

public class SettingsViewModel: ISettingsViewModel {

    private let settingsService: ISettingsService

    public init(settingsService: ISettingsService) {
        self.settingsService = settingsService
    }
}
