//
//  ViewController.swift
//  Final Project
//
//  Created by Chase on 2021/4/20.
//
import SwiftUI

struct ViewController: View {
    @StateObject var appViewModel = AppViewModel()
    @StateObject var icon_settings = Icon_Settings()
    @StateObject var gameSettings = GameSettings()
    var body: some View {
        ZStack{
            switch appViewModel.view {
            case "HomepageView":
                HomepageView().environmentObject(appViewModel).environmentObject(icon_settings).disabled(appViewModel.loading_disable)
            case "StartView":
                StartView().environmentObject(appViewModel).environmentObject(icon_settings).disabled(appViewModel.loading_disable)
            case "EditPersonalView":
                EditPersonalView().environmentObject(appViewModel)
            case "ProfileView":
                ProfileView().environmentObject(appViewModel).environmentObject(icon_settings)
            case "LobbyView":
                LobbyView().environmentObject(appViewModel).environmentObject(icon_settings).environmentObject(gameSettings)
            case "RoomView":
                RoomView().environmentObject(appViewModel).environmentObject(gameSettings)
            case "GameView":
                GameView().environmentObject(appViewModel).environmentObject(gameSettings)
            default:
                StartView().environmentObject(appViewModel)
            }
            AlertView().environmentObject(appViewModel)
        }.edgesIgnoringSafeArea(.all)
        .onAppear{
            appViewModel.appInit()
        }
    }
}
