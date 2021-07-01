//
//  Final_ProjectApp.swift
//  Final Project
//
//  Created by Chase on 2021/4/14.
//

import SwiftUI
import FacebookCore

@main
struct Final_ProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ViewController().onOpenURL(perform: { url in
                ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
            })
        }
    }
}
