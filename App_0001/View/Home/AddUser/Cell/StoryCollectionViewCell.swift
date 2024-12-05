//
//  StoryCollectionViewCell.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 05.12.24.
//

import UIKit
import SnapKit

final class StoryCollectionViewCell: UICollectionViewCell, IReusableView {

    private var image = UIImageView()

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
        self.addSubview(image)
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

    public func setup(image: UIImage) {
        self.image.image = image
    }
}
