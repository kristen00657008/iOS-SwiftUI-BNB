//
//  AppSettings.swift
//  Final Project
//
//  Created by Chase on 2021/4/20.
//

import SwiftUI
import AppTrackingTransparency

class AppViewModel: FirebaseViewModel, ObservableObject {
    @Published var user = User()
    @Published var view = "HomepageView"
    @Published var alert_msg = ""
    @Published var alert_opacity = 0.0
    @Published var loading_opacity: Double = 0
    @Published var loading_disable: Bool = false
    @Published var isSettingView: Bool = false
    var width: CGFloat
    var height: CGFloat
    
    override init() {
        self.width = UIScreen.main.bounds.width
        self.height = UIScreen.main.bounds.height
    }
    
    func appInit() {
        requestTracking()
        //logOut()
        self.view = "HomepageView"
        self.show_loading()
        isLogin() { isLogin, authId in
            if isLogin {
                self.user.authId = authId
                self.fetchUser(authId: authId) { isExist, user in
                    self.user = user
                    print("get user")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self.hide_loading()
                    self.view = "StartView"
                }
            }else {
                self.hide_loading()
            }
        }
    }
    
    func show_message(message: String) {
        alert_msg = message
        withAnimation(.easeInOut){
            alert_opacity = 0.95
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.alert_opacity = 0.0
        }
    }
    
    func show_loading() {
        self.loading_disable = true
        self.loading_opacity = 1.0
    }
    
    func hide_loading()  {
        self.loading_disable = false
        self.loading_opacity = 0.0
    }
    
    func email_login_success() {
        getAuthID() { [self] uid, email in
            user.authId = uid
            user.userAccount.email = email
        }
        fetchUser(authId: self.user.authId) { isExist, user in
            self.user = user
        }
        view = "StartView"
    }
    
    func recordsToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for record in self.user.records {
            resultDictionary.append(record.dictionary)
        }
        return resultDictionary
    }
    
    func requestTracking() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                break
            @unknown default:
                break
            }
        }
    }
    
}

