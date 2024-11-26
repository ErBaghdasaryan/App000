//
//  ReusableView.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit

protocol IReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension IReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

