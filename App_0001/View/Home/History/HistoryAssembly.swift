//
//  HistoryAssembly.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 04.12.24.
//

import Foundation
import AppViewModel
import AppModel
import Swinject
import SwinjectAutoregistration

final class HistoryAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IHistoryViewModel.self, argument: HistoryNavigationModel.self, initializer: HistoryViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IHomeService.self, initializer: HomeService.init)
    }
}
