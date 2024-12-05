//
//  EmptyCollectionViewCell.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import UIKit
import SnapKit

final class EmptyCollectionViewCell: UICollectionViewCell, IReusableView {

    private let header = UILabel(text: "Empty page",
                                 textColor: .white,
                                 font: UIFont(name: "SFProText-Bold", size: 22))
    private let subHeader = UILabel(text: "",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 16))
    private var image = UIImageView(image: .init(named: "emptyImage"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        self.subHeader.numberOfLines = 2

        self.addSubview(header)
        self.addSubview(subHeader)
        self.addSubview(image)
    }

    private func setupConstraints() {
        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(50)
            view.leading.equalToSuperview().offset(93)
            view.trailing.equalToSuperview().inset(93)
            view.height.equalTo(28)
        }

        subHeader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(93)
            view.trailing.equalToSuperview().inset(93)
            view.height.equalTo(42)
        }

        image.snp.makeConstraints { view in
            view.top.equalTo(subHeader.snp.bottom).offset(32)
            view.centerX.equalToSuperview()
            view.height.equalTo(130)
            view.width.equalTo(130)
        }
    }

    public func setup(subheader: String) {
        self.subHeader.text = subheader
    }
}
