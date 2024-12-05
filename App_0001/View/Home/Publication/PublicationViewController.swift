//
//  PublicationViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import UIKit
import AppViewModel
import SnapKit
import SDWebImage
import AVFoundation

class PublicationViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private let userImage = UIImageView()
    private let nameLabel = UILabel(text: "",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Bold", size: 13))
    private let publication = UIImageView()

    private let addToArchive = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false

        guard let user = self.viewModel?.user else { return }
        self.userImage.image = user.avatar
        self.nameLabel.text = user.username

        guard let model = self.viewModel?.posts else { return }

        if model.videoDownloadUrl == nil {
            let imageURL = model.imageDownloadUrl
            self.fetchImageUsingSDWebImage(from: imageURL) { image in
                if let image = image {

                    self.publication.layer.masksToBounds = true
                    self.publication.contentMode = .scaleAspectFill
                    self.publication.image = image
                } else {
                    print("Failed to fetch image")
                }
            }
        } else if let videoURLString = model.videoDownloadUrl,
                    let videoURL = URL(string: videoURLString) {
//            self.publication.setupVideo(url: videoURL)
//            self.publication.player?.play()
        }
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = UIColor(hex: "#111111")

        self.title = "Publications"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = 17
        self.userImage.contentMode = .scaleAspectFill

        self.nameLabel.textAlignment = .left

        self.addToArchive.setTitle("Add to archive", for: .normal)
        self.addToArchive.setTitleColor(.black, for: .normal)
        self.addToArchive.backgroundColor = .white
        self.addToArchive.layer.masksToBounds = true
        self.addToArchive.layer.cornerRadius = 8

        self.view.addSubview(userImage)
        self.view.addSubview(nameLabel)
        self.view.addSubview(addToArchive)
        self.view.addSubview(publication)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

        userImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(110)
            view.leading.equalToSuperview().offset(16)
            view.width.equalTo(34)
            view.height.equalTo(34)
        }

        nameLabel.snp.makeConstraints { view in
            view.top.equalTo(userImage.snp.top).offset(8)
            view.leading.equalTo(userImage.snp.trailing).offset(8)
            view.height.equalTo(16)
        }

        addToArchive.snp.makeConstraints { view in
            view.centerY.equalTo(userImage.snp.centerY)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(28)
        }

        publication.snp.makeConstraints { view in
            view.top.equalTo(userImage.snp.bottom).offset(12)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(390)
        }
    }

}

//MARK: Make buttons actions
extension PublicationViewController {
    
    private func makeButtonsAction() {
        addToArchive.addTarget(self, action: #selector(addArchive), for: .touchUpInside)
    }

    @objc func addArchive() {
        guard let navigationController = self.navigationController else { return }

        AddUserRouter.popViewController(in: navigationController)
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
}

extension PublicationViewController: IViewModelableController {
    typealias ViewModel = IPublicationViewModel
}

//MARK: Preview
import SwiftUI

struct PublicationViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let publicationViewController = PublicationViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PublicationViewControllerProvider.ContainerView>) -> PublicationViewController {
            return publicationViewController
        }

        func updateUIViewController(_ uiViewController: PublicationViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PublicationViewControllerProvider.ContainerView>) {
        }
    }
}
