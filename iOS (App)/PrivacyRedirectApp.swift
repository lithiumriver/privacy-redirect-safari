//
//  PrivacyRedirectApp.swift
//  Privacy Redirect
//
//  Created by FIGBERT on 6/21/21.
//

import SwiftUI

@main
struct PrivacyRedirectApp: App {
    let defaults = UserDefaults(suiteName: "group.com.lithiumriver.Privacy-Redirect-for-Safari")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .defaultAppStorage(defaults!)
        }
    }
}
