//
//  OnboardingViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppViewModel
import SnapKit
import StoreKit

class OnboardingViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    var collectionView: UICollectionView!
    private let bottomView = UIView()
    private let header = UILabel(text: "Header",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 34))
    private let descriptionLabel = UILabel(text: "Description",
                                           textColor: .white.withAlphaComponent(0.7),
                                           font: UIFont(name: "SFProText-Semibold", size: 17))
    private let pageControl = AdvancedPageControlView()
    private let skipButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private var buttonsStack: UIStackView!
    private var currentIndex: Int = 0

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

        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 1

        self.skipButton.setTitle("Skip", for: .normal)
        self.skipButton.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        self.skipButton.backgroundColor = .clear
        self.skipButton.layer.masksToBounds = true
        self.skipButton.layer.cornerRadius = 16
        self.skipButton.layer.borderWidth = 1
        self.skipButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor

        self.nextButton.setTitle("Next", for: .normal)
        self.nextButton.setTitleColor(.black, for: .normal)
        self.nextButton.backgroundColor = UIColor.white
        self.nextButton.layer.masksToBounds = true
        self.nextButton.layer.cornerRadius = 16

        self.buttonsStack = UIStackView(arrangedSubviews: [skipButton, nextButton],
                                        axis: .horizontal,
                                        spacing: 10)

        let mylayout = UICollectionViewFlowLayout()
        mylayout.itemSize = sizeForItem()
        mylayout.scrollDirection = .horizontal
        mylayout.minimumLineSpacing = 0
        mylayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: mylayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(OnboardingCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false

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
        pageControl.setPage(0)

        self.view.addSubview(collectionView)
        self.view.addSubview(bottomView)
        self.view.addSubview(header)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(buttonsStack)
        self.view.addSubview(pageControl)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel?.loadData()
    }

    func sizeForItem() -> CGSize {
        let deviceType = UIDevice.currentDeviceType

        switch deviceType {
        case .iPhone:
            let width = self.view.frame.size.width - 88
            let heightt = self.view.frame.size.height - 225
            return CGSize(width: width, height: heightt)
        case .iPad:
            let scaleFactor: CGFloat = 1.5
            let width = 550 * scaleFactor
            let height = 1100 * scaleFactor
            return CGSize(width: width, height: height)
        }
    }

    func setupConstraints() {
        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(310)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(130)
            view.leading.equalToSuperview().offset(44)
            view.trailing.equalToSuperview().inset(44)
            view.bottom.equalToSuperview().inset(98)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(32)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(34)
        }

        descriptionLabel.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(38)
            view.trailing.equalToSuperview().inset(38)
            view.height.equalTo(22)
        }

         buttonsStack.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(53)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(54)
        }

        pageControl.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(78)
            view.leading.equalToSuperview().offset(60)
            view.trailing.equalToSuperview().inset(60)
            view.height.equalTo(6)
        }
    }

}

//MARK: Make buttons actions
extension OnboardingViewController {
    
    private func makeButtonsAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTaped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }

    private func resetLabelSizes(to page: Int) {
        switch page {
        case 1:
            pageControl.setPage(1)
            header.snp.remakeConstraints { view in
                view.top.equalTo(bottomView.snp.top).offset(43)
                view.leading.equalToSuperview().offset(24)
                view.trailing.equalToSuperview().inset(24)
                view.height.equalTo(34)
            }

            descriptionLabel.snp.remakeConstraints { view in
                view.top.equalTo(header.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(66)
                view.trailing.equalToSuperview().inset(66)
                view.height.equalTo(44)
            }

            self.header.numberOfLines = 1
            self.descriptionLabel.numberOfLines = 2
        case 2:
            pageControl.setPage(2)
            header.snp.remakeConstraints { view in
                view.top.equalTo(bottomView.snp.top).offset(43)
                view.leading.equalToSuperview().offset(24)
                view.trailing.equalToSuperview().inset(24)
                view.height.equalTo(34)
            }

            descriptionLabel.snp.remakeConstraints { view in
                view.top.equalTo(header.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(66)
                view.trailing.equalToSuperview().inset(66)
                view.height.equalTo(44)
            }

            self.header.numberOfLines = 1
            self.descriptionLabel.numberOfLines = 2
        case 3:
            pageControl.setPage(3)
            collectionView.snp.remakeConstraints { view in
                view.top.equalToSuperview().offset(164)
                view.leading.equalToSuperview().offset(44)
                view.trailing.equalToSuperview().inset(44)
                view.bottom.equalToSuperview().inset(275)
            }

            header.snp.remakeConstraints { view in
                view.top.equalTo(bottomView.snp.top).offset(43)
                view.leading.equalToSuperview().offset(24)
                view.trailing.equalToSuperview().inset(24)
                view.height.equalTo(82)
            }

            descriptionLabel.snp.remakeConstraints { view in
                view.top.equalTo(header.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(66)
                view.trailing.equalToSuperview().inset(66)
                view.height.equalTo(22)
            }

            self.header.numberOfLines = 2
            self.descriptionLabel.numberOfLines = 1
            self.rate()
        default:
            pageControl.setPage(0)
            collectionView.snp.remakeConstraints { view in
                view.top.equalToSuperview().offset(130)
                view.leading.equalToSuperview().offset(44)
                view.trailing.equalToSuperview().inset(44)
                view.bottom.equalToSuperview().inset(98)
            }

            header.snp.remakeConstraints { view in
                view.top.equalTo(bottomView.snp.top).offset(32)
                view.leading.equalToSuperview().offset(16)
                view.trailing.equalToSuperview().inset(16)
                view.height.equalTo(34)
            }

            descriptionLabel.snp.remakeConstraints { view in
                view.top.equalTo(header.snp.bottom).offset(12)
                view.leading.equalToSuperview().offset(38)
                view.trailing.equalToSuperview().inset(38)
                view.height.equalTo(22)
            }
            self.header.numberOfLines = 1
            self.descriptionLabel.numberOfLines = 1
        }
    }

    @objc func skipButtonTapped() {
        guard let navigationController = self.navigationController else { return }
        OnboardingRouter.showPaymentViewController(in: navigationController)
    }

    @objc func nextButtonTaped() {
        guard let navigationController = self.navigationController else { return }

        let numberOfItems = self.collectionView.numberOfItems(inSection: 0)
        let nextRow = self.currentIndex + 1

        if nextRow < numberOfItems {
            let nextIndexPath = IndexPath(item: nextRow, section: 0)
            self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            self.currentIndex = nextRow
            self.resetLabelSizes(to: currentIndex)
        } else {
            OnboardingRouter.showPaymentViewController(in: navigationController)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleItems = collectionView.indexPathsForVisibleItems.sorted()
        if let visibleItem = visibleItems.first {
            currentIndex = visibleItem.item
        }
    }

    private func rate() {
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
}

extension OnboardingViewController: IViewModelableController {
    typealias ViewModel = IOnboardingViewModel
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.onboardingItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCell = collectionView.dequeueReusableCell(for: indexPath)
        descriptionLabel.text = viewModel?.onboardingItems[indexPath.row].description
        header.text = viewModel?.onboardingItems[indexPath.row].header
        cell.setup(image: viewModel?.onboardingItems[indexPath.row].image ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 3 {
            let width = self.view.frame.size.width - 80
            let heightt = self.view.frame.size.height - 403
            return CGSize(width: width, height: heightt)
        }

        return sizeForItem()
    }
}

//MARK: Preview
import SwiftUI

struct OnboardingViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let onboardingViewController = OnboardingViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<OnboardingViewControllerProvider.ContainerView>) -> OnboardingViewController {
            return onboardingViewController
        }

        func updateUIViewController(_ uiViewController: OnboardingViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<OnboardingViewControllerProvider.ContainerView>) {
        }
    }
}
