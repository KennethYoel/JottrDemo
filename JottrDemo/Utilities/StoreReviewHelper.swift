//
//  RequestReview.swift
//  JottrDemo
//
//  Used by Kenneth Gutierrez on 10/13/22.
//  Created by Iiro Alhonen https://iiroalhonen.medium.com/asking-for-reviews-in-ios-14-apps-b0aaf3a34988
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        guard var appOpenCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.APP_OPENED_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
    }
    
    static func checkAndAskForReview() {
        // Call this whenever appropriate.
        // This will not be shown everytime. Apple has some internal logic on how to show this.
        guard let appOpenCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.APP_OPENED_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
            return
        }
        
        switch appOpenCount {
        case 10,50:
            StoreReviewHelper().requestReview()
        case _ where appOpenCount%100 == 0 :
            StoreReviewHelper().requestReview()
        default:
            print("App run count is : \(appOpenCount)")
            break;
        }
        
    }
    
    func requestReview() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.currentScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
}

extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}

struct UserDefaultsKeys {
    static let APP_OPENED_COUNT = "APP_OPENED_COUNT"
}
