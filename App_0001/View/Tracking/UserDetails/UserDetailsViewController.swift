//
//  UserDetailsViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import UIKit
import AppViewModel
import AppModel
import SnapKit
import SDWebImage

class UserDetailsViewController: BaseViewController {

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
    private var stories: [StoryItem] = []
    private var publicationItems: [PostItem] = []

    var collectionView: UICollectionView!
    private var isStory: Bool = true

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

        let numberOfColumns: CGFloat = 3
        let spacing: CGFloat = 1
        let totalSpacing = ((numberOfColumns - 1) * spacing)
        let availableWidth = self.view.frame.width - totalSpacing
        let itemWidth = availableWidth / numberOfColumns

        let myLayout = UICollectionViewFlowLayout()
        myLayout.itemSize = CGSize(width: itemWidth, height: 230)
        myLayout.scrollDirection = .vertical
        myLayout.minimumLineSpacing = spacing
        myLayout.minimumInteritemSpacing = spacing

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: myLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(StoryCollectionViewCell.self)
        collectionView.register(EmptyCollectionViewCell.self)

        collectionView.delegate = self
        collectionView.dataSource = self

        self.navigationController?.navigationBar.tintColor = .white

        self.view.addSubview(image)
        self.view.addSubview(seeStory)
        self.view.addSubview(name)
        self.view.addSubview(line)
        self.view.addSubview(statStack)
        self.view.addSubview(descriptionView)
        self.view.addSubview(buttonsStack)
        self.view.addSubview(collectionView)
        setupConstraints()
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

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(buttonsStack.snp.bottom).offset(6)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    override func setupViewModel() {
        super.setupViewModel()
        let nickName = self.viewModel?.user.username
        self.title = "\(nickName!)"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        guard let model = self.viewModel?.user else { return }
        
        let stroyParams = ["url": model.requestedURL,
                      "token": "0118a92e-50df-48k72-8442-63043f133a61"]
        self.viewModel?.doCall(from: "https://proinstsave.site/api/profile/stories",
                               httpMethod: "GET",
                               urlParam: stroyParams,
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
                    self.collectionView.reloadData()
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        })

        let publicationParams = ["url": model.requestedURL,
                                 "token": "0118a92e-50df-48k72-8442-63043f133a61"]
        self.viewModel?.doCall(from: "https://proinstsave.site/api/profile/posts",
                               httpMethod: "GET",
                               urlParam: publicationParams,
                               responseModel: PostsResponseModel.self,
                               completion: { (result: Result<PostsResponseModel, Error>) in
            switch result {
            case .success(let result):
                let items = result.data.profilePosts.items
                if !items.isEmpty {
                    self.publicationItems = items
                    self.collectionView.reloadData()
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

//MARK: Make buttons actions
extension UserDetailsViewController {

    private func makeButtonsAction() {
        storiesButton.addTarget(self, action: #selector(handleButtonAction(_:)), for: .touchUpInside)
        publicationButton.addTarget(self, action: #selector(handleButtonAction(_:)), for: .touchUpInside)
        seeStory.addTarget(self, action: #selector(openHistoryPage), for: .touchUpInside)
    }

    @objc func openHistoryPage() {
        guard let navigationController = self.navigationController else { return }
        guard let userInfo = self.viewModel?.user else { return }
        let stories = self.stories

        let model = HistoryNavigationModel(user: userInfo,
                                           stories: stories)

        UserDetailsRouter.showHistoryViewController(in: navigationController, navigationModel: model)
    }

    private func openSpecificStory(from story: StoryItem) {
        guard let navigationController = self.navigationController else { return }
        guard let userInfo = self.viewModel?.user else { return }

        let stories = [story]

        let model = HistoryNavigationModel(user: userInfo,
                                           stories: stories)

        UserDetailsRouter.showHistoryViewController(in: navigationController, navigationModel: model)
    }

    private func openPublication(from: PostItem) {
        guard let navigationController = self.navigationController else { return }
        guard let userInfo = self.viewModel?.user else { return }

        let model = PublicationNavigationModel(user: userInfo, posts: from)

        UserDetailsRouter.showPublicationViewController(in: navigationController, navigationModel: model)
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
            self.isStory = true
            self.collectionView.reloadData()
        case publicationButton:
            storiesButton.isVisible = false
            publicationButton.isVisible = true
            self.isStory = false
            self.collectionView.reloadData()
        default:
            break
        }
    }

    private func setupNavigationItems() {

        let addButton = UIButton(type: .system)
        addButton.setImage(.init(named: "archiveButton"), for: .normal)
        addButton.addTarget(self, action: #selector(openArchive), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = barButton
        self.navigationController?.navigationBar.tintColor = .white
    }

    private func fetchImageUsingSDWebImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        SDWebImageManager.shared.loadImage(
            with: url,
            options: .highPriority,
            progress: nil
        ) { image, data, error, cacheType, finished, imageURL in
            if let error = error {
                print("Failed to fetch image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            completion(image)
        }
    }

    @objc private func openArchive() {
//        guard let navigationController = self.navigationController else { return }
//        guard let model = self.viewModel?.user else { return }

//        self.viewModel?.editUser(model: .init(id: model.id,
//                                              userID: model.userID,
//                                              name: model.name,
//                                              username: model.username,
//                                              avatar: model.avatar,
//                                              description: model.description,
//                                              totalPublications: model.totalPublications,
//                                              totalSubscribers: model.totalSubscribers,
//                                              totalSubscriptions: model.totalSubscriptions,
//                                              requestedURL: model.requestedURL,
//                                              isSaved: true))
//
//        HomeRouter.popViewController(in: navigationController)
    }

}

extension UserDetailsViewController: IViewModelableController {
    typealias ViewModel = IUserDetailsViewModel
}

extension UserDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isStory {
            if self.stories.count == 0 {
                return 1
            } else {
                return self.stories.count
            }
        } else {
            if self.publicationItems.count == 0 {
                return 1
            } else {
                return self.publicationItems.count
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isStory {
            if self.stories.count == 0 {
                let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setup(subheader: "There are no acting stories here.")
                return cell
            } else {
                
                let cell: StoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                let model = self.stories[indexPath.row]
                
                if model.videoDownloadUrl == nil {
                    let imageURL = model.imageDownloadUrl
                    self.fetchImageUsingSDWebImage(from: imageURL) { image in
                        if let image = image {
                            cell.setup(image: image)
                        } else {
                            print("Failed to fetch image")
                        }
                    }
                } else {
                    let thumbnail = model.thumbnail
                    self.fetchImageUsingSDWebImage(from: thumbnail) { image in
                        if let image = image {
                            cell.setup(image: image)
                        } else {
                            print("Failed to fetch image")
                        }
                    }
                }
                
                return cell
            }

        } else {
            if self.publicationItems.count == 0 {
                let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setup(subheader: "There are no photo publications here.")
                return cell
            } else {
                let cell: StoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                let model = self.publicationItems[indexPath.row]
                
                if model.videoDownloadUrl == nil {
                    let imageURL = model.imageDownloadUrl
                    self.fetchImageUsingSDWebImage(from: imageURL) { image in
                        if let image = image {
                            cell.setup(image: image)
                        } else {
                            print("Failed to fetch image")
                        }
                    }
                } else {
                    let thumbnail = model.thumbnail
                    self.fetchImageUsingSDWebImage(from: thumbnail) { image in
                        if let image = image {
                            cell.setup(image: image)
                        } else {
                            print("Failed to fetch image")
                        }
                    }
                }
                
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isStory {
            if self.stories.count == 0 {
                return CGSize(width: 390, height: 255)
            } else {
                let numberOfColumns: CGFloat = 3
                let spacing: CGFloat = 1
                let totalSpacing = ((numberOfColumns - 1) * spacing)
                let availableWidth = self.view.frame.width - totalSpacing
                let itemWidth = availableWidth / numberOfColumns

                return CGSize(width: itemWidth, height: 230)
            }
        } else {
            if self.publicationItems.count == 0 {
                return CGSize(width: 390, height: 255)
            } else {
                let numberOfColumns: CGFloat = 3
                let spacing: CGFloat = 1
                let totalSpacing = ((numberOfColumns - 1) * spacing)
                let availableWidth = self.view.frame.width - totalSpacing
                let itemWidth = availableWidth / numberOfColumns
                
                return CGSize(width: itemWidth, height: 150)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if isStory {
            if self.stories.count == 0 {
                return
            } else {
                let item = self.stories[indexPath.row]
                openSpecificStory(from: item)
            }
        } else {
            if self.publicationItems.count == 0 {
                return
            } else {
                let publication = self.publicationItems[indexPath.row]
                openPublication(from: publication)
            }
        }
    }
}


//MARK: Preview
import SwiftUI

struct UserDetailsViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let userDetailsViewController = UserDetailsViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<UserDetailsViewControllerProvider.ContainerView>) -> UserDetailsViewController {
            return userDetailsViewController
        }

        func updateUIViewController(_ uiViewController: UserDetailsViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UserDetailsViewControllerProvider.ContainerView>) {
        }
    }
}
