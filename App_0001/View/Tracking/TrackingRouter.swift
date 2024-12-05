//
//  TrackingRouter.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import UIKit
import AppViewModel
import AppModel

final class TrackingRouter: BaseRouter {

    static func showUserDetailsViewController(in navigationController: UINavigationController, navigationModel: UserNavigationModel) {
        let viewController = ViewControllerFactory.makeUserDetailsViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = false
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
