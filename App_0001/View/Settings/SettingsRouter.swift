//
//  SettingsRouter.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import UIKit
import AppViewModel

final class SettingsRouter: BaseRouter {
    static func showUsageViewController(in navigationController: UINavigationController) {
//        let viewController = ViewControllerFactory.makeTabBarViewController()
//        viewController.navigationItem.hidesBackButton = true
//        navigationController.navigationBar.isHidden = true
//        navigationController.pushViewController(viewController, animated: true)
    }

    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: false)
    }
}
