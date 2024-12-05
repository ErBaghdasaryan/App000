//
//  UserDetailsAssembly.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import Foundation
import AppViewModel
import AppModel
import Swinject
import SwinjectAutoregistration

final class UserDetailsAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IUserDetailsViewModel.self, argument: UserNavigationModel.self, initializer: UserDetailsViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IHomeService.self, initializer: HomeService.init)
    }
}
