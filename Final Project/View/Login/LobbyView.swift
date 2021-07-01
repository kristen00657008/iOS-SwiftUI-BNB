//
//  ProfileView.swift
//  FinalProject-part2
//
//  Created by Chase on 2021/4/20.
//

import SwiftUI
import AVFoundation

struct LobbyView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var icon_settings: Icon_Settings
    @EnvironmentObject var gameSettings: GameSettings
    var body: some View {
        ZStack{
            Color.init(red: 89/255, green: 165/255, blue: 216/255).edgesIgnoringSafeArea(.all)
            
            UserInfoView
            
            /*Button(action: {
                print("room: \(gameSettings.room)")
                print("myCode:\(gameSettings.enterCode)")
            }, label: {
                Text("Print")
                    .font(.title)
                    .foregroundColor(.black)
            }).position(x: appViewModel.width * 0.5, y: appViewModel.height * 0.05)*/
            
            Button(action: {
                withAnimation{
                    appViewModel.isSettingView = true
                }
            }, label: {
                Image("gear")
                    .resizable()
                    .frame(width: appViewModel.width * 0.03, height: appViewModel.width * 0.03)
            }).position(x: appViewModel.width * 0.95, y: appViewModel.height * 0.05)
            
            HStack{
                Button(action: {
                    gameSettings.createRoomBtn(user: appViewModel.user.userInfo){
                        appViewModel.view = "RoomView"
                    }
                }, label: {
                    Text("創建房間")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.15)
                        .background(Color.init(red: 239/255, green: 239/255, blue: 208/255))
                        .cornerRadius(10)
                })
            }
            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.6)
            .background(Color.init(red: 26/255, green: 101/255, blue: 158/255))
            .cornerRadius(15)
            .position(x: UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.height * 0.5)
            
            VStack{
                Text("輸入邀請碼")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                
                TextField("", text: $gameSettings.enterCode)
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(5)
                
                Button(action: {
                    gameSettings.joinRoomBtn(user: appViewModel.user.userInfo) { (result) in
                        switch result {
                        case true:
                            print("join room success")
                            appViewModel.view = "RoomView"
                            AVPlayer.playWaitMusic()
                        case false:
                            print("join room fail")
                            appViewModel.show_message(message: "此房間不存在")
                        }
                    }
                }, label: {
                    Text("加入房間")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.15)
                        .background(Color.init(red: 239/255, green: 239/255, blue: 208/255))
                        .cornerRadius(10)
                })
            }
            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.6)
            .background(Color.init(red: 26/255, green: 101/255, blue: 158/255))
            .cornerRadius(15)
            .position(x: UIScreen.main.bounds.width * 0.75, y: UIScreen.main.bounds.height * 0.5)
            
        }.edgesIgnoringSafeArea(.all)
        .onAppear{
            gameSettings.enterCode = ""
            AVPlayer.playLobbyMusic()
        }
        .disabled(appViewModel.isSettingView ? true : false)
        
        if appViewModel.isSettingView {
            SettingView().environmentObject(appViewModel).transition(.bottomTransition)
        }
        
    }
    
    var UserInfoView: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color.black)
            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.15)
            .overlay(
                HStack(spacing: 0){
                    icon_settings.current_photo_Img
                        .resizable()
                        .frame(width: UIScreen.main.bounds.height * 0.13, height: UIScreen.main.bounds.height * 0.13)
                        .cornerRadius(5)
                        .padding(.leading, 5)
                    
                    Text(appViewModel.user.userInfo.nickname)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05, alignment: .leading)
                        .padding(.leading, 5)
                }
            )
            .position(x: UIScreen.main.bounds.width * 0.2, y: UIScreen.main.bounds.height * 0.06)
            .onTapGesture {
                appViewModel.view = "ProfileView"
            }
    }
}

