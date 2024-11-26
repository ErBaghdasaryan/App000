//
//  TabBarViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppViewModel
import SnapKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        lazy var homeViewController = self.createNavigation(title: "Home",
                                                            image: "home",
                                                            vc: ViewControllerFactory.makeHomeViewController())

        lazy var trackingViewController = self.createNavigation(title: "Tracking",
                                                                image: "tracking",
                                                                vc: ViewControllerFactory.makeTrackingViewController())

        lazy var settingsPageViewController = self.createNavigation(title: "Settings",
                                                                    image: "settings",
                                                                    vc: ViewControllerFactory.makeSettingsViewController())

        self.setViewControllers([homeViewController, trackingViewController, settingsPageViewController], animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setCurrentPageToTeam), name: Notification.Name("ResetCompleted"), object: nil)

        homeViewController.delegate = self
        trackingViewController.delegate = self
        settingsPageViewController.delegate = self
    }

    @objc func setCurrentPageToTeam() {
        self.selectedIndex = 0
    }

    private func createNavigation(title: String, image: String, vc: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: vc)
        self.tabBar.backgroundColor = UIColor.black
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor

        let unselectedImage = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: image)?.withTintColor(.white, renderingMode: .alwaysTemplate)

        navigation.tabBarItem.image = unselectedImage
        navigation.tabBarItem.selectedImage = selectedImage

        navigation.tabBarItem.title = title

        let nonselectedTitleColor: UIColor = UIColor.white.withAlphaComponent(0.5)
        let selectedTitleColor: UIColor = UIColor.white

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: nonselectedTitleColor
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedTitleColor
        ]

        navigation.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        navigation.tabBarItem.setTitleTextAttributes(normalAttributes, for: .normal)

        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.5)

        return navigation
    }

    // MARK: - Deinit
    deinit {
        #if DEBUG
        print("deinit \(String(describing: self))")
        #endif
    }
}

//MARK: Navigation & TabBar Hidden
extension TabBarViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.hidesBottomBarWhenPushed {
            self.tabBar.isHidden = true
        } else {
            self.tabBar.isHidden = false
        }
    }
}

//MARK: Preview
import SwiftUI

struct TabBarViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tabBarViewController = TabBarViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarViewControllerProvider.ContainerView>) -> TabBarViewController {
            return tabBarViewController
        }

        func updateUIViewController(_ uiViewController: TabBarViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TabBarViewControllerProvider.ContainerView>) {
        }
    }
}
