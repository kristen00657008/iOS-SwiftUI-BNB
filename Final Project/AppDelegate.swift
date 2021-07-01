//
//  AppDelegate.swift
//  Final Project
//
//  Created by Chase on 2021/4/14.
//

import UIKit
import Firebase
import FacebookCore
import AVFoundation
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    @AppStorage("volume") var volume = 0.5
    @AppStorage("isMute") var isMuted = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure() //Firebase
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions) //FB
        AVPlayer.queuePlayer.volume = Float(volume)
        AVPlayer.queuePlayer.isMuted = self.isMuted
        AVPlayer.playLoginMusic()
        
        return true
    }
}


