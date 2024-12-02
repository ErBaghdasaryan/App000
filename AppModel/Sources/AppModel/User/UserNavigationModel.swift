//
//  UserNavigationModel.swift
//
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import Foundation
import Combine

public final class UserNavigationModel {
    public var activateSuccessSubject: PassthroughSubject<Bool, Never>
    public var model: UserModel
    
    public init(activateSuccessSubject: PassthroughSubject<Bool, Never>, model: UserModel) {
        self.activateSuccessSubject = activateSuccessSubject
        self.model = model
    }
}
