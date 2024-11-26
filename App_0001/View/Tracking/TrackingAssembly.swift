//
//  TrackingAssembly.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import AppViewModel
import Swinject
import SwinjectAutoregistration

final class TrackingAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(ITrackingViewModel.self, initializer: TrackingViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(ITrackingService.self, initializer: TrackingService.init)
    }
}
