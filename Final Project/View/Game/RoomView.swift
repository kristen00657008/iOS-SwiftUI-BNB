//
//  RoomView.swift
//  Final Project
//
//  Created by Chase on 2021/5/12.
//

import SwiftUI
import AVFoundation

struct RoomView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var gameSettings: GameSettings
    let exitNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("Host exit"))
    let startNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("game start"))
    
    var body: some View {
        ZStack{
            Color.init(red: 89/255, green: 165/255, blue: 216/255).edgesIgnoringSafeArea(.all)
            Text("邀請碼: \(gameSettings.room.invitationCode)")
                .font(.title)
                .position(x: appViewModel.width * 0.8, y: appViewModel.height * 0.05)
                .foregroundColor(.black)
            
            /*Button(action: {
                print("myIndex: \(gameSettings.myIndex)")
                print(gameSettings.room)
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
            
            Button(action: {
                appViewModel.view = "LobbyView"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    gameSettings.ExitRoomBtn()
                    gameSettings.roomListener!.remove()
                }
            }, label: {
                Image("back")
                    .resizable()
                    .frame(width: 35, height: 35)
                
            }).position(x: appViewModel.width * 0.06, y: appViewModel.height * 0.07)
            
            Button(action: {
                appViewModel.show_message(message: gameSettings.roomBtn())
                
            }, label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: appViewModel.width * 0.2, height: appViewModel.height * 0.1)
                    .foregroundColor(.yellow)
                    .overlay(
                        Text(gameSettings.room.users[gameSettings.myIndex].isHost ? "開 始 遊 戲" : gameSettings.room.users[gameSettings.myIndex].isReady ? "取消準備" : "準    備")
                            .foregroundColor(.black)
                            .font(.title)
                    )
            }) .position(x: appViewModel.width * 0.5, y: appViewModel.height * 0.9)
            
            HStack(spacing: 20){
                ForEach(0..<4) { index in
                    RoomUserView(index: index).environmentObject(appViewModel).environmentObject(gameSettings)
                }
            }
            .frame(width: appViewModel.width * 1, height: appViewModel.height * 0.7)
            .background(Color.init(red: 56/255, green: 111/255, blue: 164/255))
            .position(x: appViewModel.width * 0.5, y: appViewModel.height * 0.5)
            
        }.edgesIgnoringSafeArea(.all)
        .onAppear{
            AVPlayer.playWaitMusic()
            gameSettings.roomDetect(id: gameSettings.room.id!){ changetype, room in
                print(changetype)
                if changetype == "modified"{
                    gameSettings.room = room
                    gameSettings.myIndex = room.users.firstIndex(where: { $0.id == gameSettings.myId })!
                    if room.isPlaying {
                        print("game starting")
                        NotificationCenter.default.post(name: Notification.Name("game start"), object: nil)
                    }
                } else {
                    print("removed")
                    if !gameSettings.room.users[gameSettings.myIndex].isHost {
                        NotificationCenter.default.post(name: Notification.Name("Host exit"), object: nil)
                    }
                }
            }
        }
        .onReceive(exitNotificaiton, perform: { _ in
            print("Host Exit")
            gameSettings.roomListener!.remove()
            appViewModel.view = "LobbyView"
        })
        .onReceive(startNotificaiton, perform: { _ in
            print("Start")
            print(gameSettings.room.GameID)
            gameSettings.roomListener!.remove()
            appViewModel.show_message(message: "遊戲即將開始")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                appViewModel.view = "GameView"
            }
        })
        .disabled(appViewModel.isSettingView ? true : false)
        
        if appViewModel.isSettingView {
            SettingView().environmentObject(appViewModel).transition(.bottomTransition)
        }
        
    }
}

struct  RoomUserView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var gameSettings: GameSettings
    var index: Int = 0
    
    var body: some View {
        VStack(spacing: 5){
            ZStack{
                if index < gameSettings.room.users.count   {
                    Image("").data(url: URL(string: gameSettings.room.users[index].imgUrl)!)
                        .resizable()
                        .frame(width: appViewModel.width * 0.15, height: appViewModel.width * 0.15)
                        .cornerRadius(15)
                        .colorMultiply(Color.init(red: 237/255, green: 224/255, blue: 212/255))
                }
            }
            .frame(width: appViewModel.width * 0.2, height: appViewModel.width * 0.2)
            .background(Color.init(red: 145/255, green: 229/255, blue: 246/255))
            .cornerRadius(15)
            
            ZStack{
                VStack(spacing: 0){
                    HStack{
                        if index < gameSettings.room.users.count {
                            Image(gameSettings.room.users[index].gender)
                                .resizable()
                                .frame(width: appViewModel.width * 0.04, height: appViewModel.width * 0.04)
                                .clipShape(Circle())
                                .padding(.leading, 5)
                            Text(gameSettings.room.users[index].nickname)
                                .font(.title)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }.frame(width: appViewModel.width * 0.2, height: appViewModel.width * 0.05)
                    
                    if index < gameSettings.room.users.count {
                        ZStack{
                            Text(gameSettings.room.users[index].isHost ? "室      長": "準      備")
                                .foregroundColor(gameSettings.room.users[index].isReady ? .black : .white)
                        }
                        .frame(width: appViewModel.width * 0.18, height: appViewModel.height * 0.08)
                        .background(gameSettings.room.users[index].isReady ? Color.yellow : Color.init(red: 31/255, green: 72/255, blue: 126/255))
                        .cornerRadius(5)
                    }else {
                        ZStack{
                            Text("準      備")
                                .foregroundColor(.white)
                        }
                        .frame(width: appViewModel.width * 0.18, height: appViewModel.height * 0.08)
                        .background(Color.init(red: 31/255, green: 72/255, blue: 126/255))
                        .cornerRadius(5)
                    }
                }
                .frame(width: appViewModel.width * 0.2, height: appViewModel.width * 0.1)
                .background(Color.init(red: 89/255, green: 165/255, blue: 216/255))
                .cornerRadius(15)
            }
        }
    }
}

