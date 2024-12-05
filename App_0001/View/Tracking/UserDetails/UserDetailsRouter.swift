//
//  UserDetailsRouter.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import Foundation
import UIKit
import AppViewModel
import AppModel

final class UserDetailsRouter: BaseRouter {

    static func showHistoryViewController(in navigationController: UINavigationController, navigationModel: HistoryNavigationModel) {
        let viewController = ViewControllerFactory.makeHistoryViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showPublicationViewController(in navigationController: UINavigationController, navigationModel: PublicationNavigationModel) {
        let viewController = ViewControllerFactory.makePublicationViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = false
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
