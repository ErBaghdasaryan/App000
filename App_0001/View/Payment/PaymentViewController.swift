//
//  PaymentViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 27.11.24.
//

import UIKit
import AppViewModel
import SnapKit
import ApphudSDK

final class PaymentViewController: BaseViewController {

    var viewModel: ViewModel?

    private let topImage = UIImageView(image: .init(named: "paymentImage"))
    private let bottomView = UIView()
    private let header = UILabel(text: "Choose your plan",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 34))
    private let forFreeButton = UIButton(type: .system)
    private let continueButton = UIButton(type: .system)
    private var currentIndex: Int = 0

    private let yearlyButton = PaymentButton(isYearly: .yearly)
    private let monthlyButton = PaymentButton(isYearly: .monthly)
    private var plansStack: UIStackView!

    private let privacyButton = UIButton(type: .system)
    private let restoreButton = UIButton(type: .system)
    private let termsButton = UIButton(type: .system)
    private var bottomStack: UIStackView!

    private var currentProduct: ApphudProduct?
    public let paywallID = "main"
    public var productsAppHud: [ApphudProduct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
        self.loadPaywalls()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func setupUI() {
        super.setupUI()

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black, UIColor(hex: "#ED1F1F")!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = [0.1, 1.1]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at: 0)

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bottomView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let overlayView = UIView()
        overlayView.backgroundColor = UIColor(hex: "#1B1B1B1A")?.withAlphaComponent(0.1)
        overlayView.frame = blurEffectView.bounds
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        bottomView.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(overlayView)

        bottomView.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 25

        header.textAlignment = .center
        header.numberOfLines = 1

        self.forFreeButton.setImage(.init(named: "paymentClose"), for: .normal)

        self.continueButton.setTitle("Continue", for: .normal)
        self.continueButton.setTitleColor(.black, for: .normal)
        self.continueButton.backgroundColor = UIColor.white
        self.continueButton.layer.masksToBounds = true
        self.continueButton.layer.cornerRadius = 16

        self.plansStack = UIStackView(arrangedSubviews: [yearlyButton,
                                                         monthlyButton],
                                      axis: .vertical,
                                      spacing: 12)

        self.privacyButton.setTitle("Privacy Policy", for: .normal)
        self.privacyButton.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        self.privacyButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)
        self.restoreButton.setTitle("Restore Purchases", for: .normal)
        self.restoreButton.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        self.restoreButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)
        self.termsButton.setTitle("Terms of Use", for: .normal)
        self.termsButton.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        self.termsButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)
        self.bottomStack = UIStackView(arrangedSubviews: [privacyButton, restoreButton, termsButton],
                                       axis: .horizontal,
                                       spacing: 12)

        self.view.addSubview(topImage)
        self.view.addSubview(bottomView)
        self.view.addSubview(header)
        self.view.addSubview(continueButton)
        self.view.addSubview(forFreeButton)
        self.view.addSubview(plansStack)
        self.view.addSubview(bottomStack)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {
        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(394)
        }

        topImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(110)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(274)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(32)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(41)
        }

        continueButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(88)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(54)
        }

        forFreeButton.snp.makeConstraints { view in
            view.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(11)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(22)
            view.width.equalTo(23)
        }

        plansStack.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(29)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(118)
        }

        bottomStack.snp.makeConstraints { view in
            view.top.equalTo(continueButton.snp.bottom).offset(26)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(13)
        }
    }

}

//MARK: Make buttons actions
extension PaymentViewController {
    
    private func makeButtonsAction() {
        continueButton.addTarget(self, action: #selector(continueButtonTaped), for: .touchUpInside)
        forFreeButton.addTarget(self, action: #selector(forFreeButtonTapped), for: .touchUpInside)
        yearlyButton.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
        monthlyButton.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restore), for: .touchUpInside)
    }

    @objc func privacyTapped() {
        guard let navigationController = self.navigationController else { return }
        PaymentRouter.showUsageViewController(in: navigationController)
    }

    @objc func termsTapped() {
        guard let navigationController = self.navigationController else { return }
        PaymentRouter.showTermsViewController(in: navigationController)
    }

    @objc func restore() {
        guard let navigationController = self.navigationController else { return }
        self.restorePurchase { result in
            print("Restore completed!")
        }

        let viewControllers = navigationController.viewControllers

        if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
            let previousViewController = viewControllers[currentIndex - 1]

            if previousViewController is OnboardingViewController {
                UntilOnboardingRouter.showTabBarViewController(in: navigationController)
            } else {
                UntilOnboardingRouter.popViewController(in: navigationController)
            }
        }
    }

    private func returnName(product: ApphudProduct) -> String {
        guard let subsciptionPeriod = product.skProduct?.subscriptionPeriod else { return "" }

        switch subsciptionPeriod.unit {
        case .year:
            return "Yearly $49.99"
        case .week:
            return "Week"
        case .day:
            return "Day"
        case .month:
            return "Monthly $6.99"
        @unknown default:
            return "Unknown"
        }
    }

    @objc func planAction(_ sender: UIButton) {
        switch sender {
        case yearlyButton:
            self.yearlyButton.isSelectedState = true
            self.monthlyButton.isSelectedState = false
            self.currentProduct = self.productsAppHud.first
        case monthlyButton:
            self.yearlyButton.isSelectedState = false
            self.monthlyButton.isSelectedState = true
            self.currentProduct = self.productsAppHud[1]
        default:
            break
        }
    }

    @objc func forFreeButtonTapped() {
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers

            if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
                let previousViewController = viewControllers[currentIndex - 1]

                if previousViewController is OnboardingViewController {
                    UntilOnboardingRouter.showTabBarViewController(in: navigationController)
                } else {
                    UntilOnboardingRouter.popViewController(in: navigationController)
                }
            }
        }
    }

    @objc func continueButtonTaped() {
        if let navigationController = self.navigationController {
            guard let currentProduct = self.currentProduct else { return }

            startPurchase(product: currentProduct) { result in
                let viewControllers = navigationController.viewControllers

                if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
                    let previousViewController = viewControllers[currentIndex - 1]

                    if previousViewController is OnboardingViewController {
                        UntilOnboardingRouter.showTabBarViewController(in: navigationController)
                    } else {
                        UntilOnboardingRouter.popViewController(in: navigationController)
                    }
                }
            }
        }

    }

    @MainActor 
    func startPurchase(product: ApphudProduct, escaping: @escaping(Bool) -> Void) {
        let selectedProduct = product
        Apphud.purchase(selectedProduct) { result in
            if let error = result.error {
                print(error.localizedDescription)
                escaping(false)
            }

            if let subscription = result.subscription, subscription.isActive() {
                escaping(true)
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
                escaping(true)
            } else {
                if Apphud.hasActiveSubscription() {
                    escaping(true)
                }
            }
        }
    }

    @MainActor
    func restorePurchase(escaping: @escaping(Bool) -> Void) {
        Apphud.restorePurchases { subscriptions, _, error in
            if let error = error {
                print(error.localizedDescription)
                escaping(false)
            }
            if subscriptions?.first?.isActive() ?? false {
                escaping(true)
            }
            if Apphud.hasActiveSubscription() {
                escaping(true)
            }
        }
    }

    @MainActor
    public func loadPaywalls() {
        Apphud.paywallsDidLoadCallback { paywalls, arg in
            if let paywall = paywalls.first(where: { $0.identifier == self.paywallID }) {
                Apphud.paywallShown(paywall)

                let products = paywall.products
                self.productsAppHud = products
            }
        }
    }
}

extension PaymentViewController: IViewModelableController {
    typealias ViewModel = IPaymentViewModel
}

//MARK: Preview
import SwiftUI

struct PaymentViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let paymentViewController = PaymentViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PaymentViewControllerProvider.ContainerView>) -> PaymentViewController {
            return paymentViewController
        }

        func updateUIViewController(_ uiViewController: PaymentViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PaymentViewControllerProvider.ContainerView>) {
        }
    }
}
