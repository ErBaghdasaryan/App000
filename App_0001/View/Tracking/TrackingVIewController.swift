//
//  TrackingVIewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppViewModel
import SnapKit

class TrackingVIewController: BaseViewController {

    var viewModel: ViewModel?

    private let header = UILabel(text: "Users",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 34))
    private let tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
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

        self.title = "Tracking"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.header.textAlignment = .left

        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true

        self.view.addSubview(header)
        self.view.addSubview(tableView)
        setupConstraints()
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

        tableView.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }

        tableView.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false

        self.tableView.register(SavedUserTableViewCell.self)
    }
}


extension TrackingVIewController: IViewModelableController {
    typealias ViewModel = ITrackingViewModel
}

//MARK: Make buttons actions
extension TrackingVIewController{
    
    private func makeButtonsAction() {
        
    }

    private func editUser(for index: Int) {
        guard let navigationController = self.navigationController else { return }
        self.viewModel?.loadData()
        let model = self.viewModel?.users[index]

        TrackingRouter.showUserDetailsViewController(in: navigationController,
                                             navigationModel: .init(activateSuccessSubject: self.viewModel!.activateSuccessSubject, model: model!))
    }

    private func deleteUser(by index: Int) {
        let deletedUderId = self.viewModel?.users[index].id

        let alert = UIAlertController(title: "Delete a user",
                                      message: "Are you sure you want to remove this user from your list?",
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel?.deleteUser(by: deletedUderId!)
            self.viewModel?.loadData()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX,
                                                  y: self.view.bounds.maxY - 100,
                                                  width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: TableView Delegate & Data source
extension TrackingVIewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.users.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SavedUserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let model = viewModel?.users[indexPath.row] {
            cell.setup(image: model.avatar,
                       name: model.name,
                       nickname: model.username)
        }

        cell.deleteSubject.sink { [weak self] _ in
            self?.deleteUser(by: indexPath.row)
        }.store(in: &cell.cancellables)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editUser(for: indexPath.row)
    }
}

//MARK: Preview
import SwiftUI

struct TrackingVIewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let trackingVIewController = TrackingVIewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<TrackingVIewControllerProvider.ContainerView>) -> TrackingVIewController {
            return trackingVIewController
        }

        func updateUIViewController(_ uiViewController: TrackingVIewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TrackingVIewControllerProvider.ContainerView>) {
        }
    }
}
