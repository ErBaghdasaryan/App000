//
//  UntilOnboardingViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppViewModel
import SnapKit

class UntilOnboardingViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private let logoImage = UIImageView(image: .init(named: "Image"))
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let progressLabel = UILabel(text: "Progress",
                                        textColor: UIColor.white,
                                        font: UIFont(name: "SFProText-Regular", size: 17))

    private var progress: Float = 1.0 {
        willSet {
            self.progressLabel.text = "Loading \(Int(newValue))%"
        }
    }
    private var timer: Timer?
    private var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#111111")

        progressView.progressTintColor = .white
        progressView.trackTintColor = UIColor(hex: "#1A242D")
        progressView.layer.cornerRadius = 25

        self.logoImage.layer.masksToBounds = true
        self.logoImage.layer.cornerRadius = 40

        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()

    }

    func setupConstraints() {
        self.view.addSubview(logoImage)
        self.view.addSubview(progressLabel)
        self.view.addSubview(progressView)

        logoImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(199)
            view.centerX.equalToSuperview()
            view.height.equalTo(162)
            view.width.equalTo(162)
        }

        progressLabel.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(167)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(22)
        }

        progressView.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(203)
            view.centerX.equalToSuperview()
            view.width.equalTo(204)
            view.height.equalTo(10)
        }
    }
}


extension UntilOnboardingViewController: IViewModelableController {
    typealias ViewModel = IUntilOnboardingViewModel
}

//MARK: Progress View
extension UntilOnboardingViewController {
    private func startLoading() {
        progressView.progress = 0.0
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }

    @objc private func updateProgress(timer: Timer) {
        guard let _ = self.navigationController else { return }
        if progressView.progress < 1.0 {
            if self.progress < 100  {
                self.progress += 1
            }
            UIView.animate(withDuration: 1) {
                self.progressView.progress += 0.01
            }
        } else {
            timer.invalidate()
            goToNextPage()
        }
    }

    private func goToNextPage() {
        guard let navigationController = self.navigationController else { return }
        guard var viewModel = self.viewModel else { return }
        if viewModel.appStorageService.hasData(for: .skipOnboarding) {
            UntilOnboardingRouter.showTabBarViewController(in: navigationController)
        } else {
            viewModel.skipOnboarding = true
            UntilOnboardingRouter.showOnboardingViewController(in: navigationController)
        }
    }
}

//MARK: Preview
import SwiftUI

struct UntilOnboardingViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let untilOnboardingViewController = UntilOnboardingViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<UntilOnboardingViewControllerProvider.ContainerView>) -> UntilOnboardingViewController {
            return untilOnboardingViewController
        }

        func updateUIViewController(_ uiViewController: UntilOnboardingViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UntilOnboardingViewControllerProvider.ContainerView>) {
        }
    }
}
