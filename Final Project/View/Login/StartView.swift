//
//  StartView.swift
//  Final Project
//
//  Created by Chase on 2021/4/20.
//

import SwiftUI
import AVFoundation

struct StartView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var icon_settings: Icon_Settings
    @State private var flag = false
    @State private var showAlert = false
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            LoadingView().opacity(appViewModel.loading_opacity)
            Text("Touch to Start")
                .foregroundColor(.white)
                .colorMultiply(flag ? .red : .purple)
                .font(Font.system(size: 55))
                .position(x: appViewModel.width * 0.5, y: appViewModel.height * 0.92)
            Button(action: {
                showAlert = true
            }, label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: appViewModel.width * 0.08, height: appViewModel.height * 0.08)
                    .foregroundColor(Color.gray)
                    .shadow(radius: 5)
                    .overlay(
                        Text("登出")
                            .font(Font.system(size: 20))
                            .foregroundColor(.white)
                    )
            }).position(x: appViewModel.width * 0.9, y: appViewModel.height * 0.05)
            
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert) {
            return Alert(title: Text("確定要登出？"), message: Text(""), primaryButton: .default(Text("取消"), action: {
                print("取消登出")
            }), secondaryButton: .default(Text("確定"), action: {
                print("確定登出")
                appViewModel.logOut()
                appViewModel.user = User()
                appViewModel.view = "HomepageView"
            }))
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever()) {
                flag.toggle()
            }
        }
        .onTapGesture {
            //fatalError()
            appViewModel.show_loading()
            if appViewModel.user.userInfo.imgUrl != "" {
                icon_settings.current_photo_Img = Image(systemName: "person.fill").data(url: URL(string: appViewModel.user.userInfo.imgUrl)!)
            }
            else {
                icon_settings.current_photo_Img = Image(systemName: "person.fill")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                appViewModel.hide_loading()
                appViewModel.view = "LobbyView"
            }
        }
    }
    
}
