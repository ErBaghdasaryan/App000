//
//  PublicationsButton.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 03.12.24.
//

import UIKit
import AppModel

final class PublicationsButton: UIButton {
    private let defaultImage = UIImageView()
    private let bottomView = UIView()
    public var isVisible: Bool = false {
        willSet {
            if newValue {
                self.bottomView.isHidden = false
            } else {
                self.bottomView.isHidden = true
            }
        }
    }

    public init(image: String) {
        self.defaultImage.image = UIImage(named: image)
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor(hex: "#111111")

        self.bottomView.isHidden = true

        self.bottomView.backgroundColor = .white

        addSubview(defaultImage)
        addSubview(bottomView)
        setupConstraints()
    }

    private func setupConstraints() {
        defaultImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(32)
            view.centerX.equalToSuperview()
            view.width.equalTo(22)
            view.height.equalTo(21)
        }

        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(0.5)
        }
    }
}
