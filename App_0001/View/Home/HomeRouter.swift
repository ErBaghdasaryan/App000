//
//  HomeRouter.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import UIKit
import AppViewModel
import AppModel

final class HomeRouter: BaseRouter {

    static func showAddUserViewController(in navigationController: UINavigationController, navigationModel: UserNavigationModel) {
        let viewController = ViewControllerFactory.makeAddUserViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = false
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
