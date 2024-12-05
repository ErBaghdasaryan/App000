//
//  AddUserViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 02.12.24.
//

import Foundation
import AppModel

public protocol IAddUserViewModel {
    var user: UserModel { get set }
    func editUser(model: UserModel)
    func doCall<T: Decodable>(
        from urlString: String,
        httpMethod: String,
        urlParam: [String: String],
        responseModel: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

public class AddUserViewModel: IAddUserViewModel {

    private let homeService: IHomeService
    public var user: UserModel

    public init(homeService: IHomeService, navigationModel: UserNavigationModel) {
        self.homeService = homeService
        self.user = navigationModel.model
    }

    public func editUser(model: UserModel) {
        do {
            try self.homeService.editUser(model)
        } catch {
            print(error)
        }
    }

    public func doCall<T: Decodable>(
        from urlString: String,
        httpMethod: String = "GET",
        urlParam: [String: String],
        responseModel: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var components = URLComponents(string: urlString)
        components?.queryItems = urlParam.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let finalURL = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = httpMethod

        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 1
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 120

        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(responseModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}

