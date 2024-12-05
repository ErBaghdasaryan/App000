//
//  PaymentViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 27.11.24.
//

import UIKit
import AppViewModel
import SnapKit

final class PaymentViewController: BaseViewController {

    var viewModel: ViewModel?

    private let topImage = UIImageView(image: .init(named: "paymentImage"))
    private let bottomView = UIView()
    private let header = UILabel(text: "Choose your plan",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 34))
    private let pageControl = AdvancedPageControlView()
    private let forFreeButton = UIButton(type: .system)
    private let continueButton = UIButton(type: .system)
    private var currentIndex: Int = 0

    private let yearlyButton = PaymentButton(isYearly: .yearly)
    private let monthlyButton = PaymentButton(isYearly: .monthly)
    private var plansStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
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

        self.forFreeButton.setTitle("Continue for free", for: .normal)
        self.forFreeButton.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        self.forFreeButton.backgroundColor = .clear

        self.continueButton.setTitle("Continue", for: .normal)
        self.continueButton.setTitleColor(.black, for: .normal)
        self.continueButton.backgroundColor = UIColor.white
        self.continueButton.layer.masksToBounds = true
        self.continueButton.layer.cornerRadius = 16

        pageControl.drawer = ExtendedDotDrawer(numberOfPages: 4,
                                               height: 6,
                                               width: 63,
                                               space: 6,
                                               indicatorColor: UIColor.white,
                                               dotsColor: UIColor.white.withAlphaComponent(0.4),
                                               isBordered: true,
                                               borderWidth: 0.0,
                                               indicatorBorderColor: .orange,
                                               indicatorBorderWidth: 0.0)
        pageControl.setPage(4)

        self.plansStack = UIStackView(arrangedSubviews: [yearlyButton,
                                                         monthlyButton],
                                      axis: .vertical,
                                      spacing: 12)

        self.view.addSubview(topImage)
        self.view.addSubview(bottomView)
        self.view.addSubview(header)
        self.view.addSubview(continueButton)
        self.view.addSubview(forFreeButton)
        self.view.addSubview(pageControl)
        self.view.addSubview(plansStack)
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
            view.top.equalToSuperview().offset(138)
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
            view.top.equalTo(continueButton.snp.bottom).offset(10)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(33)
        }

        pageControl.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(78)
            view.leading.equalToSuperview().offset(60)
            view.trailing.equalToSuperview().inset(60)
            view.height.equalTo(6)
        }

        plansStack.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(29)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(118)
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
    }

    @objc func planAction(_ sender: UIButton) {
        switch sender {
        case yearlyButton:
            self.yearlyButton.isSelectedState = true
            self.monthlyButton.isSelectedState = false
        case monthlyButton:
            self.yearlyButton.isSelectedState = false
            self.monthlyButton.isSelectedState = true
        default:
            break
        }
    }

    @objc func forFreeButtonTapped() {
        guard let navigationController = self.navigationController else { return }
        OnboardingRouter.showTabBarViewController(in: navigationController)
    }

    @objc func continueButtonTaped() {
        guard let navigationController = self.navigationController else { return }
        OnboardingRouter.showTabBarViewController(in: navigationController)
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
