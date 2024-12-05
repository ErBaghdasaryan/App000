//
//  SettingsViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppViewModel
import SnapKit
import StoreKit

class SettingsViewController: BaseViewController {

    var viewModel: ViewModel?

    private let subscribe = SubscribeButton()
    private let usage = SettingsView(title: "Usage policy",
                                     image: "usage")
    private let rate = SettingsView(title: "Rate our app",
                                     image: "rate")
    private let share = SettingsView(title: "Share our app",
                                     image: "share")

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonActions()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#111111")

        self.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.view.addSubview(subscribe)
        self.view.addSubview(usage)
        self.view.addSubview(rate)
        self.view.addSubview(share)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()

    }

    func setupConstraints() {
        subscribe.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(121)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(60)
        }

        rate.snp.makeConstraints { view in
            view.top.equalTo(subscribe.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(60)
        }

        share.snp.makeConstraints { view in
            view.top.equalTo(rate.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(60)
        }

        usage.snp.makeConstraints { view in
            view.top.equalTo(share.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(60)
        }
    }
}


extension SettingsViewController: IViewModelableController {
    typealias ViewModel = ISettingsViewModel
}

//MARK: Button Actions
extension SettingsViewController {
    private func makeButtonActions() {
        self.usage.addTarget(self, action: #selector(usageTapped), for: .touchUpInside)
        self.rate.addTarget(self, action: #selector(rateTapped), for: .touchUpInside)
        self.share.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        self.subscribe.addTarget(self, action: #selector(openSubscribtion), for: .touchUpInside)
    }

    @objc func openSubscribtion() {
        guard let navigationController = self.navigationController else { return }

        SettingsRouter.showPaymentViewController(in: navigationController)
    }

    @objc func shareTapped() {
        let appStoreURL = URL(string: "https://apps.apple.com/us/app/id6738990497")!

        let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .openInIBooks,
            .markupAsPDF
        ]

        present(activityViewController, animated: true, completion: nil)
    }

    @objc func rateTapped() {
        guard let scene = view.window?.windowScene else { return }
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview()
        } else {
            let alertController = UIAlertController(
                title: "Enjoying the app?",
                message: "Please consider leaving us a review in the App Store!",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Go to App Store", style: .default) { _ in
                if let appStoreURL = URL(string: "https://apps.apple.com/us/app/id6738990497") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
            })
            present(alertController, animated: true, completion: nil)
        }
    }

    @objc func usageTapped() {
        guard let navigationController = self.navigationController else { return }
        SettingsRouter.showUsageViewController(in: navigationController)
    }
}

//MARK: Preview
import SwiftUI

struct SettingsViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let settingsViewController = SettingsViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SettingsViewControllerProvider.ContainerView>) -> SettingsViewController {
            return settingsViewController
        }

        func updateUIViewController(_ uiViewController: SettingsViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SettingsViewControllerProvider.ContainerView>) {
        }
    }
}
