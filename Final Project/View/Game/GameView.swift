//
//  ContentView.swift
//  test
//
//  Created by Chase on 2021/5/11.
//

import SwiftUI
import AVFoundation

struct GameView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var appViewModel: AppViewModel
    let gameOverNotificaiton = NotificationCenter.default.publisher(for: Notification.Name("Game Over"))
    @State private var isGameOver = false
    @State private var gameViewOpacity: Double = 1
    var gameStartMusic: AVPlayer = AVPlayer.gameStartPlayer
    
    var body: some View {
        ZStack{
            MapView()
                .environmentObject(gameSettings)
                .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
            BombView()
                .environmentObject(gameSettings)
                .position(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.86)
            
            JoystickView()
                .environmentObject(gameSettings)
                .position(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.8)
            PropView()
                .environmentObject(gameSettings)
                .position(x: UIScreen.main.bounds.width * 0.93, y: UIScreen.main.bounds.height * 0.7)
                
            if isGameOver {
                GameOverView.transition(.bottomTransition)
            }
            
            Button(action: {
                gameSettings.game.players[gameSettings.myIndex].bombNum += 1
                gameSettings.updatePlayers(id: gameSettings.room.GameID, playersDictionary: gameSettings.playersToDictionary())
            }, label: {
                Text("增加水球數").foregroundColor(.black)
            }).position(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.2)
            Button(action: {
                if gameSettings.game.players[gameSettings.myIndex].bombNum > 1 {
                    gameSettings.game.players[gameSettings.myIndex].bombNum -= 1
                    gameSettings.updatePlayers(id: gameSettings.room.GameID, playersDictionary: gameSettings.playersToDictionary())
                }
            }, label: {
                Text("減少水球數").foregroundColor(.black)
            }).position(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.3)
            Button(action: {
                gameSettings.game.players[gameSettings.myIndex].bombPower += 1
                gameSettings.updatePlayers(id: gameSettings.room.GameID, playersDictionary: gameSettings.playersToDictionary())
            }, label: {
                Text("增加水球力量").foregroundColor(.black)
            }).position(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.4)
            Button(action: {
                if gameSettings.game.players[gameSettings.myIndex].bombPower > 1 {
                    gameSettings.game.players[gameSettings.myIndex].bombPower -= 1
                    gameSettings.updatePlayers(id: gameSettings.room.GameID, playersDictionary: gameSettings.playersToDictionary())
                }
            }, label: {
                Text("減少水球力量").foregroundColor(.black)
            }).position(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.5)
            
            Button(action: {
                print("myIndex:\(gameSettings.myIndex)")
                print("userNum:\(gameSettings.game.userNum)")
                print("currentBombs:\(gameSettings.game.currentBombs)")
                print("currentRow:\(gameSettings.game.playersLocation[gameSettings.myIndex].currentRow)")
                print("currentCol:\(gameSettings.game.playersLocation[gameSettings.myIndex].currentCol)")
                print("ItemIndex:\(gameSettings.game.playersLocation[gameSettings.myIndex].currentRow * 15 + gameSettings.game.playersLocation[gameSettings.myIndex].currentCol)")
            }, label: {
                Text("Print").foregroundColor(.black)
            }).position(x: UIScreen.main.bounds.width * 0.85, y: UIScreen.main.bounds.height * 0.6)
        }
        .opacity(self.gameViewOpacity)
        .background(Color.init(red: 165/255, green: 148/255, blue: 249/255))
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            AVPlayer.playGameMusic()
            gameSettings.gameDetect(id: gameSettings.room.GameID){ game in
                gameSettings.game = game
                if game.isGameOver {
                    NotificationCenter.default.post(name: Notification.Name("Game Over"), object: nil)
                }
            }
            gameStartMusic.playFromStart()
        }
        .onReceive(gameOverNotificaiton, perform: { _ in
            print("Game Over")
            self.isGameOver = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 10 ) {
                appViewModel.view = "LobbyView"
                if gameSettings.room.users[gameSettings.myIndex].isHost {
                    gameSettings.deleteGame(id: gameSettings.room.GameID)
                    gameSettings.deleteRoom(id: gameSettings.room.id!)
                }
            }
        })
    }
    
    var GameOverView: some View {
        ZStack{
            Color.init(red: 142/255, green: 202/255, blue: 230/255)
            if gameSettings.game.players[gameSettings.myIndex].winning {
                Text("勝    利")
                    .font(Font.system(size: 100))
                    .foregroundColor(.yellow)
                    .onAppear{
                        AVPlayer.winPlayer.playFromStart()
                    }
            }else {
                Text("失    敗")
                    .font(Font.system(size: 100))
                    .foregroundColor(.black)
                    .onAppear{
                        AVPlayer.losePlayer.playFromStart()
                    }
            }
        }
        .frame(width: appViewModel.width * 0.7, height: appViewModel.height * 0.4)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.init(red: 2/255, green: 48/255, blue: 71/255), lineWidth: 8))
        .onAppear{
            var result = ""
            var rank = 1
            if gameSettings.game.players[gameSettings.myIndex].winning {
                result = "勝利"
                rank = 1
            } else {
                result = "失敗"
                rank = 2
            }
            appViewModel.user.records.append(Record(id: appViewModel.user.records.count, result: result, rank: rank, mode: "1v1模式"))
            appViewModel.updateRecords(id: appViewModel.user.id!, recordsToDictionary: appViewModel.recordsToDictionary())
        }
    }
    
}

