//
//  SavedUserTableViewCell.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import UIKit
import SnapKit
import AppViewModel
import AppModel
import Combine

final class SavedUserTableViewCell: UITableViewCell, IReusableView {

    private let content = UIView()

    private let subheader = UILabel(text: "",
                                    textColor: UIColor.white.withAlphaComponent(0.7),
                               font: UIFont(name: "SFProText-Regular", size: 13))
    private let header = UILabel(text: "",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Semibold", size: 17))
    private let image = UIImageView()
    private let delete = UIButton(type: .system)

    public var deleteSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    private func setupUI() {

        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.content.backgroundColor = UIColor(hex: "#111111")

        self.subheader.textAlignment = .left
        self.header.textAlignment = .left

        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 27
        self.image.contentMode = .scaleAspectFill

        self.delete.setImage(.init(named: "savedTrash"), for: .normal)

        addSubview(content)
        self.content.addSubview(image)
        self.content.addSubview(header)
        self.content.addSubview(subheader)
        self.content.addSubview(delete)
        setupConstraints()
        makeButtonActions()
    }

    private func setupConstraints() {

        content.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(8)
            view.leading.equalToSuperview().offset(3)
            view.trailing.equalToSuperview().inset(3)
            view.bottom.equalToSuperview().inset(8)
        }

        image.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview().offset(5)
            view.width.equalTo(54)
            view.height.equalTo(54)
        }

        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(6)
            view.leading.equalTo(image.snp.trailing).offset(13)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(22)
        }

        subheader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(2)
            view.leading.equalTo(image.snp.trailing).offset(13)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(18)
        }

        delete.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(15)
            view.trailing.equalToSuperview()
            view.height.equalTo(24)
            view.width.equalTo(22)
        }
    }

    public func setup(image: UIImage, name: String, nickname: String) {
        self.subheader.text = name
        self.header.text = nickname

        self.image.image = image

        self.setupUI()
    }
}

extension SavedUserTableViewCell {
    private func makeButtonActions() {
        self.delete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    @objc func deleteButtonTapped() {
        self.deleteSubject.send(true)
    }
}
