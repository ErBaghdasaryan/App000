//
//  ViewControllerFactory.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import Swinject
import AppModel
import AppViewModel

final class ViewControllerFactory {
    private static let commonAssemblies: [Assembly] = [ServiceAssembly()]

    //MARK: - UntilOnboarding
    static func makeUntilOnboardingViewController() -> UntilOnboardingViewController {
        let assembler = Assembler(commonAssemblies + [UntilOnboardingAssembly()])
        let viewController = UntilOnboardingViewController()
        viewController.viewModel = assembler.resolver.resolve(IUntilOnboardingViewModel.self)
        return viewController
    }

    //MARK: Onboarding
    static func makeOnboardingViewController() -> OnboardingViewController {
        let assembler = Assembler(commonAssemblies + [OnboardingAssembly()])
        let viewController = OnboardingViewController()
        viewController.viewModel = assembler.resolver.resolve(IOnboardingViewModel.self)
        return viewController
    }

    //MARK: Payment
    static func makePaymentViewController() -> PaymentViewController {
        let assembler = Assembler(commonAssemblies + [PaymentAssembly()])
        let viewController = PaymentViewController()
        viewController.viewModel = assembler.resolver.resolve(IPaymentViewModel.self)
        return viewController
    }

    //MARK: - TabBar
    static func makeTabBarViewController() -> TabBarViewController {
        let viewController = TabBarViewController()
        return viewController
    }

    //MARK: Home
    static func makeHomeViewController() -> HomeViewController {
        let assembler = Assembler(commonAssemblies + [HomeAssembly()])
        let viewController = HomeViewController()
        viewController.viewModel = assembler.resolver.resolve(IHomeViewModel.self)
        return viewController
    }

    //MARK: AddUser
    static func makeAddUserViewController(navigationModel: UserNavigationModel) -> AddUserViewController {
        let assembler = Assembler(commonAssemblies + [AddUserAssembly()])
        let viewController = AddUserViewController()
        viewController.viewModel = assembler.resolver.resolve(IAddUserViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: Tracking
    static func makeTrackingViewController() -> TrackingVIewController {
        let assembler = Assembler(commonAssemblies + [TrackingAssembly()])
        let viewController = TrackingVIewController()
        viewController.viewModel = assembler.resolver.resolve(ITrackingViewModel.self)
        return viewController
    }

    //MARK: Settings
    static func makeSettingsViewController() -> SettingsViewController {
        let assembler = Assembler(commonAssemblies + [SettingsAssembly()])
        let viewController = SettingsViewController()
        viewController.viewModel = assembler.resolver.resolve(ISettingsViewModel.self)
        return viewController
    }
}
