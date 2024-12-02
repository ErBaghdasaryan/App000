//
//  AddUserAssembly.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import Foundation
import AppViewModel
import AppModel
import Swinject
import SwinjectAutoregistration

final class AddUserAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IAddUserViewModel.self, argument: UserNavigationModel.self, initializer: AddUserViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IHomeService.self, initializer: HomeService.init)
    }
}

