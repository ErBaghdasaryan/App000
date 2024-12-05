//
//  UsageViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 04.12.24.
//

import UIKit
import WebKit
import SnapKit

final class UsageViewController: BaseViewController {

    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.webView.backgroundColor = .clear
        if let url = URL(string: "https://docs.google.com/document/d/1tZU2VqzrxXvRuuktLlhrg1nEZkXacoLH8ccpudQ266o/edit?usp=sharing") {
            webView.load(URLRequest(url: url))
        }

        setupConstraints()
    }

    private func setupConstraints() {
        self.view.addSubview(webView)

        webView.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
        }
    }

    override func setupViewModel() {

    }

}

import SwiftUI

struct UsageViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let usageViewController = UsageViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<UsageViewControllerProvider.ContainerView>) -> UsageViewController {
            return usageViewController
        }

        func updateUIViewController(_ uiViewController: UsageViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UsageViewControllerProvider.ContainerView>) {
        }
    }
}
