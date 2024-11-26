//
//  TrackingVIewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppViewModel
import SnapKit

class TrackingVIewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        self.view.backgroundColor = UIColor(hex: "#111111")

        self.title = "Tracking"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()

    }

    func setupConstraints() {
        
    }
}


extension TrackingVIewController: IViewModelableController {
    typealias ViewModel = ITrackingViewModel
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
