//
//  StatView.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 03.12.24.
//

import UIKit
import AppModel

final class StatView: UIView {
    private let title = UILabel(text: "",
                                textColor: .white.withAlphaComponent(0.7),
                                font: UIFont(name: "SFProText-Regular", size: 15))
    private let count = UILabel(text: "",
                                textColor: UIColor.white,
                                font: UIFont(name: "SFProText-Semibold", size: 20))

    public init(title: String) {
        self.title.text = title
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        addSubview(count)
        addSubview(title)
        setupConstraints()
    }

    private func setupConstraints() {
        count.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(25)
        }

        title.snp.makeConstraints { view in
            view.top.equalTo(count.snp.bottom).offset(6)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(20)
        }
    }

    public func setup(with count: String) {
        self.count.text = count
        self.setupUI()
    }
}
