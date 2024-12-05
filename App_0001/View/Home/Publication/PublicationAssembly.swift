//
//  PublicationAssembly.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import Foundation
import AppViewModel
import AppModel
import Swinject
import SwinjectAutoregistration

final class PublicationAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IPublicationViewModel.self, argument: PublicationNavigationModel.self, initializer: PublicationViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IHomeService.self, initializer: HomeService.init)
    }
}
