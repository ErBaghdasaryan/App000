//
//  OnboardingService.swift
//
//
//  Created by Er Baghdasaryan on 26.11.24.
//

import UIKit
import AppModel

public protocol IOnboardingService {
    func getOnboardingItems() -> [OnboardingPresentationModel]
}

public class OnboardingService: IOnboardingService {
    public init() { }

    public func getOnboardingItems() -> [OnboardingPresentationModel] {
        [
            OnboardingPresentationModel(image: "onboarding1",
                                        header: "Profile Search",
                                        description: "Search by nickname or type URL"),
            OnboardingPresentationModel(image: "onboarding2",
                                        header: "Collections",
                                        description: "Save reels, stories and posts to your collection"),
            OnboardingPresentationModel(image: "onboarding3",
                                        header: "Anonymity",
                                        description: "Browse stories and reels anonymously"),
            OnboardingPresentationModel(image: "onboarding4",
                                        header: "Rate our app in the AppStore",
                                        description: "Help make the app even better."),
        ]
    }
}
