//
//  HomeViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppViewModel
import AppModel
import SnapKit
import SDWebImage
import ApphudSDK

class HomeViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private let header = UILabel(text: "Home",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 34))
    private let searchBar = UISearchBar()
    private let subHeader = UILabel(text: "Recent",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Bold", size: 28))
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.loadData()
        self.tableView.reloadData()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#111111")

        self.header.textAlignment = .left
        self.subHeader.textAlignment = .left

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(string: "Search by nickname or type URL",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        }

        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = .gray.withAlphaComponent(0.24)
        searchBar.barTintColor = UIColor(hex: "#111111")
        searchBar.layer.masksToBounds = true
        searchBar.isTranslucent = true
        searchBar.delegate = self
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
           let leftView = textField.leftView as? UIImageView {
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = .white.withAlphaComponent(0.5)
        }
        searchBar.autocapitalizationType = .none

        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true

        activityIndicator.color = .white.withAlphaComponent(0.5)
        activityIndicator.hidesWhenStopped = true

        self.view.addSubview(header)
        self.view.addSubview(searchBar)
        self.view.addSubview(subHeader)
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
        setupConstraints()
        setupViewTapHandling()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(101)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(41)
        }

        searchBar.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(10)
            view.trailing.equalToSuperview().inset(10)
            view.height.equalTo(36)
        }

        subHeader.snp.makeConstraints { view in
            view.top.equalTo(searchBar.snp.bottom).offset(39)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(34)
        }

        tableView.snp.makeConstraints { view in
            view.top.equalTo(subHeader.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }

        tableView.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)

        activityIndicator.snp.makeConstraints { view in
            view.centerX.equalToSuperview()
            view.centerY.equalToSuperview()
            view.height.equalTo(24)
            view.width.equalTo(24)
        }
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false

        self.tableView.register(RecentTableViewCell.self)
    }
}


extension HomeViewController: IViewModelableController {
    typealias ViewModel = IHomeViewModel
}

extension HomeViewController {
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

    private func openAddUserPage(userModel: UserModel) {
        guard let navigationController = self.navigationController else { return }
        HomeRouter.showAddUserViewController(in: navigationController, navigationModel: .init(activateSuccessSubject: self.viewModel!.activateSuccessSubject, model: userModel))
    }
}


//MARK: TableView Delegate & Data source
extension HomeViewController:  UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.users.count ?? 0
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let model = viewModel?.users[indexPath.row] {
            cell.setup(image: model.avatar,
                       name: model.name,
                       nickname: model.username)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editUser(for: indexPath.row)
    }
}

//MARK: UIGesture & cell's touches
extension HomeViewController: UITextFieldDelegate, UITextViewDelegate {

    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }

    private func setupViewTapHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }

    private func editUser(for index: Int) {
        guard let navigationController = self.navigationController else { return }
        self.viewModel?.loadData()
        let model = self.viewModel?.users[index]

        HomeRouter.showAddUserViewController(in: navigationController,
                                             navigationModel: .init(activateSuccessSubject: self.viewModel!.activateSuccessSubject, model: model!))
    }
}

//MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel?.filterCollection(with: searchText)
//        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        viewModel?.filterCollection(with: "")
//        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchKey = "searchCount"
        let maxFreeSearches = 10
        let currentSearchCount = UserDefaults.standard.integer(forKey: searchKey)

        if currentSearchCount < maxFreeSearches || Apphud.hasActiveSubscription()  {

            UserDefaults.standard.set(currentSearchCount + 1, forKey: searchKey)

            guard let input = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !input.isEmpty else {
                print("Input is empty")
                return
            }

            self.view.endEditing(true)

            self.activityIndicator.startAnimating()

            let url: String
            if input.contains("https://") {
                url = input
            } else {
                url = "https://www.instagram.com/\(input)"
            }

            let params = ["url": url,
                          "token": "0118a92e-50df-48k72-8442-63043f133a61"]
            self.viewModel?.doCall(from: "https://proinstsave.site/api/profile",
                                   httpMethod: "GET",
                                   urlParam: params,
                                   responseModel: ResponseModel.self,
                                   completion: { (result: Result<ResponseModel, Error>) in
                switch result {
                case .success(let success):

                    let imageURL = success.data.profile.avatar
                    let user = success.data.profile

                    self.fetchImageUsingSDWebImage(from: imageURL) { image in
                        if let image = image {
                            
                            let userModel = UserModel(userID: user.userID,
                                                      name: user.name,
                                                      username: user.username,
                                                      avatar: image,
                                                      description: user.description,
                                                      totalPublications: user.totalPublications,
                                                      totalSubscribers: user.totalSubscribers,
                                                      totalSubscriptions: user.totalSubscriptions,
                                                      requestedURL: user.requestedURL,
                                                      isSaved: false)
                            
                            self.viewModel?.addUser(user: userModel)
                            self.openAddUserPage(userModel: userModel)
                        } else {
                            print("Failed to fetch image")
                        }
                    }
                    self.activityIndicator.stopAnimating()
                case .failure(let failure):
                    self.activityIndicator.stopAnimating()
                }
            }) } else {
                guard let navigationController = self.navigationController else { return }
                HomeRouter.showPaymentViewController(in: navigationController)
            }
    }
}

//MARK: Preview
import SwiftUI

struct HomeViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let homeViewController = HomeViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<HomeViewControllerProvider.ContainerView>) -> HomeViewController {
            return homeViewController
        }

        func updateUIViewController(_ uiViewController: HomeViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HomeViewControllerProvider.ContainerView>) {
        }
    }
}
