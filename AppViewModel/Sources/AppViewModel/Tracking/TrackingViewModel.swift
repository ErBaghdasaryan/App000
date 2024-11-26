//
//  TrackingViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import Foundation
import AppModel

public protocol ITrackingViewModel {

}

public class TrackingViewModel: ITrackingViewModel {

    private let trackingService: ITrackingService

    public init(trackingService: ITrackingService) {
        self.trackingService = trackingService
    }
}
