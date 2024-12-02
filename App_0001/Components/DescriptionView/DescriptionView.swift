//
//  DescriptionView.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 03.12.24.
//

import UIKit
import AppModel

final class DescriptionView: UIView {
    private let title = UILabel(text: "Description",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Regular", size: 12))
    private let descriptions = UILabel(text: "",
                                       textColor: UIColor.white,
                                       font: UIFont(name: "SFProText-Regular", size: 17))

    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16

        self.title.textAlignment = .left
        self.descriptions.textAlignment = .left
        self.descriptions.numberOfLines = 2

        addSubview(title)
        addSubview(descriptions)
        setupConstraints()
    }

    private func setupConstraints() {
        title.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(16)
        }

        descriptions.snp.makeConstraints { view in
            view.top.equalTo(title.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().offset(16)
            view.height.equalTo(54)
        }
    }

    public func setup(with description: String) {
        self.descriptions.text = description
        self.setupUI()
    }
}
