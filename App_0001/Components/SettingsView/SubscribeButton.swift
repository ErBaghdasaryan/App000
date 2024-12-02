//
//  SubscribeButton.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import UIKit
import AppModel

final class SubscribeButton: UIButton {
    private let title = UILabel(text: "Subscribe",
                                textColor: .black,
                                font: UIFont(name: "SFProText-Semibold", size: 17))
    private var image = UIImageView()
    private let arrowImage = UIImageView(image: .init(named: "settingssButton")?.withRenderingMode(.alwaysTemplate))

    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10

        self.title.textAlignment = .left

        self.image.image = UIImage(named: "subscribe")

        self.arrowImage.tintColor = .black

        addSubview(image)
        addSubview(title)
        addSubview(arrowImage)
        setupConstraints()
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(18)
            view.leading.equalToSuperview().inset(16)
            view.width.equalTo(24)
            view.height.equalTo(24)
        }

        title.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(19)
            view.leading.equalTo(image.snp.trailing).offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(22)
        }

        arrowImage.snp.makeConstraints { view in
            view.centerY.equalToSuperview()
            view.trailing.equalToSuperview().inset(15)
            view.height.equalTo(11)
            view.width.equalTo(11)
        }
    }
}
