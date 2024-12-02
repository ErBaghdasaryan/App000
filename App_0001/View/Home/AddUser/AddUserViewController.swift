//
//  AddUserViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import UIKit
import AppViewModel
import SnapKit

class AddUserViewController: BaseViewController {

    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = UIColor(hex: "#111111")

        setupConstraints()
        setupNavigationItems()
    }

    private func setupConstraints() {
       
    }

    override func setupViewModel() {
        super.setupViewModel()
        let nickName = self.viewModel?.user.username
        self.title = "\(nickName!)"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

}

//MARK: Make buttons actions
extension AddUserViewController {
    
    private func makeButtonsAction() {
        
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
    }
    
    @objc private func addUser() {
        //        guard let navigationController = self.navigationController else { return }
        //        guard let subject = self.viewModel?.activateSuccessSubject else { return }
        //        NoteRouter.showAddNotesViewController(in: navigationController, navigationModel: .init(activateSuccessSubject: subject))
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
