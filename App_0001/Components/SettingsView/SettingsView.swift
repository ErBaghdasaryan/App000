//
//  SettingsView.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppModel

final class SettingsView: UIButton {
    private let title = UILabel(text: "",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Semibold", size: 17))
    private var image = UIImageView()

    public init(title: String, image: String) {
        self.title.text = title
        self.image.image = UIImage(named: image)
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor.white.withAlphaComponent(0.05)

        self.layer.cornerRadius = 10

        self.title.textAlignment = .left

        addSubview(image)
        addSubview(title)
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
    }
}
