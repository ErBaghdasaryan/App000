//
//  AddUserViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import UIKit
import AppViewModel
import AppModel
import SnapKit

class AddUserViewController: BaseViewController {

    var viewModel: ViewModel?
    private let image = UIImageView()
    private let seeStory = UIButton(type: .system)
    private let name = UILabel(text: "",
                               textColor: UIColor.white,
                               font: UIFont(name: "SFProText-Regular", size: 16))
    private let line = UIView()
    private let publications = StatView(title: "Publications")
    private let subscribers = StatView(title: "Subscribers")
    private let subscriptions = StatView(title: "Subscriptions")
    private var statStack: UIStackView!
    private let descriptionView = DescriptionView()
    private let storiesButton = PublicationsButton(image: "stories")
    private let publicationButton = PublicationsButton(image: "publications")
    private var buttonsStack: UIStackView!
    private var stories: [StoryItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = self.viewModel?.user else { return }

        self.image.image = model.avatar
        self.name.text = model.name
        self.publications.setup(with: "\(model.totalPublications)")
        self.subscribers.setup(with: model.totalSubscribers.formattedWithSuffix())
        self.subscriptions.setup(with: "\(model.totalSubscriptions)")
        self.descriptionView.setup(with: model.description)
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = UIColor(hex: "#111111")

        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 42
        self.image.contentMode = .scaleAspectFill

        self.seeStory.layer.masksToBounds = true
        self.seeStory.layer.cornerRadius = 42
        self.seeStory.isUserInteractionEnabled = false

        self.line.backgroundColor = UIColor.white.withAlphaComponent(0.05)

        self.statStack = UIStackView(arrangedSubviews: [publications, subscribers, subscriptions],
                                     axis: .horizontal,
                                     spacing: 24)
        self.statStack.distribution = .fillProportionally

        self.buttonsStack = UIStackView(arrangedSubviews: [storiesButton, publicationButton],
                                        axis: .horizontal,
                                        spacing: 0)

        self.storiesButton.isVisible = true

        self.view.addSubview(image)
        self.view.addSubview(seeStory)
        self.view.addSubview(name)
        self.view.addSubview(line)
        self.view.addSubview(statStack)
        self.view.addSubview(descriptionView)
        self.view.addSubview(buttonsStack)
        setupConstraints()
        setupNavigationItems()
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(114)
            view.centerX.equalToSuperview()
            view.width.equalTo(84)
            view.height.equalTo(84)
        }

        seeStory.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(114)
            view.centerX.equalToSuperview()
            view.width.equalTo(84)
            view.height.equalTo(84)
        }

        name.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(21)
        }

        line.snp.makeConstraints { view in
            view.top.equalTo(name.snp.bottom).offset(16)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(0.5)
        }

        statStack.snp.makeConstraints { view in
            view.top.equalTo(line.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(35)
            view.trailing.equalToSuperview().inset(35)
            view.height.equalTo(51)
        }

        descriptionView.snp.makeConstraints { view in
            view.top.equalTo(statStack.snp.bottom).offset(32)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(114)
        }

        buttonsStack.snp.makeConstraints { view in
            view.top.equalTo(descriptionView.snp.bottom)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(65)
        }
    }

    override func setupViewModel() {
        super.setupViewModel()
        let nickName = self.viewModel?.user.username
        self.title = "\(nickName!)"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        guard let model = self.viewModel?.user else { return }
        
        let params = ["url": model.requestedURL,
                      "token": "0118a92e-50df-48k72-8442-63043f133a61"]
        self.viewModel?.doCall(from: "https://proinstsave.site/api/profile/stories",
                               httpMethod: "GET",
                               urlParam: params,
                               responseModel: StoryResponseModel.self,
                               completion: { (result: Result<StoryResponseModel, Error>) in
            switch result {
            case .success(let result):
                if !result.data.profileStories.items.isEmpty {
                    self.addGradientBorder(to: self.image,
                                           colors: [UIColor(hex: "#FF18D1")!,
                                                    UIColor(hex: "#FF2323")!,
                                                    UIColor(hex: "#FFDA22")!,],
                                           borderWidth: 4)
                    self.seeStory.isUserInteractionEnabled = true
                    self.stories = result.data.profileStories.items
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

}

//MARK: Make buttons actions
extension AddUserViewController {

    private func makeButtonsAction() {
        storiesButton.addTarget(self, action: #selector(handleButtonAction(_:)), for: .touchUpInside)
        publicationButton.addTarget(self, action: #selector(handleButtonAction(_:)), for: .touchUpInside)
        seeStory.addTarget(self, action: #selector(openHistoryPage), for: .touchUpInside)
    }

    @objc func openHistoryPage() {
        guard let navigationController = self.navigationController else { return }
        guard let userInfo = self.viewModel?.user else { return }
        guard let stories = self.stories else { return }

        let model = HistoryNavigationModel(user: userInfo,
                                           stories: stories)

        AddUserRouter.showHistoryViewController(in: navigationController, navigationModel: model)
    }

    private func addGradientBorder(to imageView: UIImageView, colors: [UIColor], borderWidth: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        if let superview = imageView.superview {
            let imageViewFrameInSuperview = superview.convert(imageView.frame, to: superview)
            gradientLayer.frame = imageViewFrameInSuperview.insetBy(dx: -borderWidth, dy: -borderWidth)
        }

        gradientLayer.cornerRadius = imageView.layer.cornerRadius + borderWidth

        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: gradientLayer.bounds, cornerRadius: gradientLayer.cornerRadius)
        let innerPath = UIBezierPath(roundedRect: gradientLayer.bounds.insetBy(dx: borderWidth, dy: borderWidth),
                                     cornerRadius: imageView.layer.cornerRadius)
        path.append(innerPath)
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        gradientLayer.mask = maskLayer

        if let superview = imageView.superview {
            superview.layer.insertSublayer(gradientLayer, below: imageView.layer)
        }
    }

    @IBAction func handleButtonAction(_ sender: UIButton) {
        switch sender {
        case storiesButton:
            storiesButton.isVisible = true
            publicationButton.isVisible = false
        case publicationButton:
            storiesButton.isVisible = false
            publicationButton.isVisible = true
        default:
            break
        }
    }

    private func setupNavigationItems() {

        let addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        addButton.layer.cornerRadius = 17
        addButton.layer.masksToBounds = true
        addButton.frame = CGRect(x: 0, y: 0, width: 58, height: 34)
        addButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = barButton
        self.navigationController?.navigationBar.tintColor = .white
    }

    @objc private func addUser() {
        guard let navigationController = self.navigationController else { return }
        guard let model = self.viewModel?.user else { return }

        self.viewModel?.editUser(model: .init(id: model.id,
                                              userID: model.userID,
                                              name: model.name,
                                              username: model.username,
                                              avatar: model.avatar,
                                              description: model.description,
                                              totalPublications: model.totalPublications,
                                              totalSubscribers: model.totalSubscribers,
                                              totalSubscriptions: model.totalSubscriptions,
                                              requestedURL: model.requestedURL,
                                              isSaved: true))

        HomeRouter.popViewController(in: navigationController)
    }

}

extension AddUserViewController: IViewModelableController {
    typealias ViewModel = IAddUserViewModel
}

//MARK: Preview
import SwiftUI

struct AddUserViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let addUserViewController = AddUserViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<AddUserViewControllerProvider.ContainerView>) -> AddUserViewController {
            return addUserViewController
        }

        func updateUIViewController(_ uiViewController: AddUserViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AddUserViewControllerProvider.ContainerView>) {
        }
    }
}
