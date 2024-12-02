//
//  TrackingViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import AppModel
import Combine

public protocol ITrackingViewModel {
    func loadData()
    var users: [UserModel] { get set }
    var activateSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func deleteUser(by Id: Int)
}

public class TrackingViewModel: ITrackingViewModel {

    private let homeService: IHomeService
    public var activateSuccessSubject = PassthroughSubject<Bool, Never>()
    public var users: [UserModel] = []

    public init(homeService: IHomeService) {
        self.homeService = homeService
    }

    public func loadData() {
        do {
            users = try self.homeService.getUsers().filter { $0.isSaved == true }
        } catch {
            print(error)
        }
    }

    public func deleteUser(by Id: Int) {
        do {
            try self.homeService.deleteUser(byID: Id)
        } catch {
            print(error)
        }
    }
}
