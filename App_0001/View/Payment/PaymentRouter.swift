//
//  PaymentRouter.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 27.11.24.
//

import Foundation
import UIKit
import AppViewModel

final class PaymentRouter: BaseRouter {
    static func showTabBarViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeTabBarViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
