//
//  Setupable.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation

protocol ISetupable {
    associatedtype SetupModel
    func setup(with model: SetupModel)
}
