//
//  Prefs.swift
//  Asthm App
//
//  Created by Den Matiash on 12.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import common

fileprivate let IS_ONBOARDING_SHOWN_KEY = "isOnboardingShown";
fileprivate let IS_SUBSCRIBED_KEY = "isSubscribed"

class Prefs: Settings {
    
    func getIsOnboardingShown() -> Bool {
        guard let userId = store.state.auth.user?.id else { return true }
        return UserDefaults.standard.bool(forKey: "\(userId)\(IS_ONBOARDING_SHOWN_KEY)")
    }
    
    func putIsOnboardingShown() {
        guard let userId = store.state.auth.user?.id else { return }
        UserDefaults.standard.setValue(true, forKey: "\(userId)\(IS_ONBOARDING_SHOWN_KEY)")
    }
    
    func getIsSubscribed() -> Bool {
        UserDefaults.standard.bool(forKey: IS_SUBSCRIBED_KEY)
    }

    func putIsSubscribed(isSubscribed: Bool) {
        UserDefaults.standard.setValue(isSubscribed, forKey: IS_SUBSCRIBED_KEY)
    }
}
