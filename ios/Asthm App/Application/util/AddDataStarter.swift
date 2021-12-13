//
//  AddDataStarter.swift
//  Asthm App
//
//  Created by Den Matiash on 24.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common

class AddDataStarter {
    
    func start(_ viewController: UIViewController) {
        if SettingsKt.settings.getIsSubscribed() {
            viewController.presentModal(AddDataViewController())
        } else {
            viewController.presentModal(SubscriptionViewController(), withNavigation: false)
        }
    }
}
