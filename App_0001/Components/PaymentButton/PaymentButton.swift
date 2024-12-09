//
//  PaymentButton.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 27.11.24.
//

import UIKit
import AppModel

final class PaymentButton: UIButton {
    private let title = UILabel(text: "",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Semibold", size: 16))
    private var image = UIImageView(image: .init(named: "unselectedState"))
    private let saveLabel = UILabel(text: "SAVE 20%",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 11))
    var isSelectedState: Bool {
        willSet {
            if newValue {
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.white.cgColor
                self.image.image = UIImage(named: "selectedState")
            } else {
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.clear.cgColor
                self.image.image = UIImage(named: "unselectedState")
            }
        }
    }
    private var isYearly: PlanPresentationModel

    public init(isYearly: PlanPresentationModel, isSelectedState: Bool = false) {
        self.isYearly = isYearly
        self.isSelectedState = isSelectedState
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor.white.withAlphaComponent(0.1)

        self.layer.cornerRadius = 12

        self.title.textAlignment = .left

        self.saveLabel.backgroundColor = .black
        self.saveLabel.layer.masksToBounds = true
        self.saveLabel.layer.cornerRadius = 8

        switch self.isYearly {
        case .yearly:
            self.title.text = "Yearly $49.99"
            self.addSubview(saveLabel)
        case .monthly:
            self.title.text = "Weekly $6.99"
            break
        }

        addSubview(title)
        addSubview(image)
        setupConstraints()
    }

    private func setupConstraints() {
        title.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(100)
            view.height.equalTo(21)
        }

        image.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(14)
            view.trailing.equalToSuperview().inset(16)
            view.width.equalTo(24)
            view.height.equalTo(24)
        }

        switch self.isYearly {
        case .yearly:
            saveLabel.snp.makeConstraints { view in
                view.top.equalToSuperview().offset(-14)
                view.trailing.equalToSuperview().inset(16)
                view.width.equalTo(70)
                view.height.equalTo(25)
            }
        case .monthly:
            break
        }
    }

    public func setup(with isYearly: String) {
        self.titleLabel?.text = isYearly
    }
}

enum PlanPresentationModel {
    case yearly
    case monthly
}
