//
//  AddUserRouter.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import Foundation
import UIKit
import AppViewModel
import AppModel

final class AddUserRouter: BaseRouter {

    static func showHistoryViewController(in navigationController: UINavigationController, navigationModel: HistoryNavigationModel) {
        let viewController = ViewControllerFactory.makeHistoryViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
