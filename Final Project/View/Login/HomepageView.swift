//
//  homepage.swift
//  Final Project
//
//  Created by Chase on 2021/4/19.
//

import SwiftUI
import FirebaseAuth
import FacebookLogin
import AVFoundation

struct HomepageView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var icon_settings: Icon_Settings
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var imgUrl = ""
    @State private var isRegister = false
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                withAnimation{
                    appViewModel.isSettingView = true
                }
            }, label: {
                Image("gear")
                    .resizable()
                    .frame(width: appViewModel.width * 0.03, height: appViewModel.width * 0.03)
            }).position(x: appViewModel.width * 0.95, y: appViewModel.height * 0.05)
            
            EmailLoginView
                .position(x: UIScreen.main.bounds.width * 0.49, y: UIScreen.main.bounds.height * 0.55)
                .offset(y: -keyboard.currentHeight/2)
            if isRegister {
                EmailRegisterView.transition(.bottomTransition)
            }
            AlertView().environmentObject(appViewModel)
            LoadingView().opacity(appViewModel.loading_opacity)
        }.edgesIgnoringSafeArea(.all)
        .onAppear{
            AVPlayer.playLoginMusic()
        }.disabled(appViewModel.isSettingView ? true : false)
        
        if appViewModel.isSettingView {
            SettingView().environmentObject(appViewModel).transition(.bottomTransition)
        }
    }
    
    var EmailLoginView: some View {
        ZStack{
            EmailTextFieldView
            
            HStack{
                Button(action: {
                    email_login()
                }, label: {
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                        .frame(width: appViewModel.width * 0.16, height: appViewModel.height * 0.1)
                        .overlay(Text("Email登入").foregroundColor(.white).font(Font.system(size: 25)))
                })
                Spacer()
                Button(action: {
                    fb_SignIn()
                }, label: {
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                        .frame(width: appViewModel.width * 0.16, height: appViewModel.height * 0.1)
                        .overlay(Text("Facebook").foregroundColor(.white).font(Font.system(size: 25)))
                })
            }
            .frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.2)
            .offset(x: 0, y: appViewModel.height * 0.3)
            
            HStack{
                Text("還沒有帳號嗎？").foregroundColor(.black)
                
                Button(action: {
                    withAnimation{
                        self.isRegister = true
                    }
                }, label: {
                    Text("立即註冊").bold()
                })
            }.offset(x: 0, y: appViewModel.height * 0.2)
            
        }
        
    }
    
    var EmailRegisterView: some View {
        ZStack{
            Color.init(red: 142/255, green: 202/255, blue: 230/255)
            Text("創 建 帳 號")
                .font(Font.system(size: 60))
                .foregroundColor(.black)
                .position(x: appViewModel.width * 0.35, y: appViewModel.height * 0.12)
            
            EmailTextFieldView
            HStack{
                Button(action: {
                    withAnimation{
                        self.isRegister = false
                    }
                }, label: {
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                        .frame(width: appViewModel.width * 0.12, height: appViewModel.height * 0.1)
                        .overlay(Text("取消").foregroundColor(.white).font(Font.system(size: 25)))
                })
                Spacer()
                Button(action: {
                    if email == "" {
                        appViewModel.alert_msg = "請輸入電子信箱"
                        appViewModel.show_message(message: appViewModel.alert_msg)
                    }
                    else if password == "" {
                        appViewModel.alert_msg = "請輸入密碼"
                        appViewModel.show_message(message: appViewModel.alert_msg)
                    }
                    else{
                        email_registered()
                    }
                }, label: {
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                        .frame(width: appViewModel.width * 0.12, height: appViewModel.height * 0.1)
                        .overlay(Text("註冊").foregroundColor(.white).font(Font.system(size: 25)))
                })
            }
            .frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.2)
            .offset(x: 0, y: appViewModel.height * 0.3)
        }
        .frame(width: appViewModel.width * 0.7, height: appViewModel.height * 0.85)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.init(red: 2/255, green: 48/255, blue: 71/255), lineWidth: 8))
    }
    
    var EmailTextFieldView: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.yellow)
                .frame(width: appViewModel.width * 0.45, height: appViewModel.height * 0.45)
                .cornerRadius(25)
                .opacity(0.8)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: appViewModel.width * 0.4, height: appViewModel.height * 0.3)
                .cornerRadius(25)
                .opacity(0.8)
            VStack(spacing: 10){
                Spacer()
                HStack(spacing: 10){
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                        .frame(width: appViewModel.width * 0.14, height: appViewModel.height * 0.1)
                        .overlay(Text("遊戲帳號").foregroundColor(.white).font(Font.system(size: 25)))
                    
                    TextField("電子信箱", text: $email)
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: appViewModel.height * 0.1)
                        .background(Color.white)
                        .cornerRadius(5)
                }
                HStack(spacing: 10){
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                        .frame(width: appViewModel.width * 0.14, height: appViewModel.height * 0.1)
                        .overlay(Text("密碼").foregroundColor(.white).font(Font.system(size: 25)))
                    
                    SecureField("密碼", text: $password)
                        .foregroundColor(.black)
                        .frame(width: appViewModel.width * 0.2, height: appViewModel.height * 0.1)
                        .background(Color.white)
                        .cornerRadius(5)
                }
                Spacer()
                
            }.frame(width: appViewModel.width * 0.4, height: appViewModel.height * 0.15)
        }.frame(width: appViewModel.width * 0.4, height: appViewModel.height * 0.15)
    }
    
    func fb_SignIn() {
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email]) { (result) in
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                print("fb login ok")
                let credential =  FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (result, error) in
                    guard error == nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    print("login ok")
                    fb_login_success()
                }
            } else {
                print("login fail")
            }
        }
    }
    
    func fb_login_success() {
        appViewModel.getAuthID() { uid, email in
            appViewModel.user.authId = uid
            appViewModel.user.userAccount.email = email
        }
        appViewModel.show_loading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print(appViewModel.user.authId)
            appViewModel.hide_loading()
            get_fb_profile()
        }
    }
    
    func get_fb_photo_url()  {
        if AccessToken.current != nil {
            Profile.loadCurrentProfile { (profile, error) in
                if let profile = profile {
                    imgUrl = profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300))!.absoluteString
                }
            }
        }
    }
    
    func get_fb_profile() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
        request.start { (response, result, error) in
            if let result = result as? [String:String] {
                print(result)
                appViewModel.fetchUser(authId: appViewModel.user.authId) { isExist, user in
                    if isExist {
                        print("此fb已註冊資料庫")
                        appViewModel.user = user
                        appViewModel.view = "StartView"
                    } else{
                        print("此fb尚未註冊資料庫")
                        get_fb_photo_url()
                        appViewModel.show_loading()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            appViewModel.hide_loading()
                            appViewModel.createUser(user: appViewModel.user) { user in
                                appViewModel.user = user
                            }
                            appViewModel.view = "EditPersonalView"
                        }
                    }
                }
            }
        }
    }
    
    func email_registered() {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { result, error in
            guard let user = result?.user,
                  error == nil else {
                print(error?.localizedDescription as Any)
                errorAnalysis(error: error!.localizedDescription)
                return
            }
            //print(user.email as Any, user.uid)
            setUser(uid: user.uid)
            appViewModel.show_loading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appViewModel.hide_loading()
                appViewModel.createUser(user: appViewModel.user) { user in
                    appViewModel.user = user
                }
                appViewModel.view = "EditPersonalView"
            }
        }
    }
    func setUser(uid: String) {
        appViewModel.user.authId = uid
        appViewModel.user.userAccount.email = email
        appViewModel.user.userAccount.password = password
        appViewModel.user.userAccount.loginWay = "Email"
    }
    
    func email_login() {
        if email == "" {
            appViewModel.alert_msg = "請輸入電子信箱"
            appViewModel.show_message(message: appViewModel.alert_msg)
        }
        else if password == "" {
            appViewModel.alert_msg = "請輸入密碼"
            appViewModel.show_message(message: appViewModel.alert_msg)
        }
        else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    print(error!.localizedDescription as String)
                    errorAnalysis(error: error!.localizedDescription)
                    return
                }
                // sign success
                appViewModel.email_login_success()
            }
        }
    }
    
    func errorAnalysis(error: String) {
        if error == "The password is invalid or the user does not have a password." {
            appViewModel.alert_msg = "密碼錯誤"
        }
        else if error == "The email address is badly formatted." {
            appViewModel.alert_msg = "請輸入有效電子信箱"
        }
        else if error == "There is no user record corresponding to this identifier. The user may have been deleted." {
            appViewModel.alert_msg = "此信箱未註冊"
        }
        else if error == "The email address is already in use by another account." {
            appViewModel.alert_msg = "此信箱已被註冊"
        }
        appViewModel.show_message(message: appViewModel.alert_msg)
    }
}

