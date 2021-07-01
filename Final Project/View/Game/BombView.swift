//
//  BombView.swift
//  test
//
//  Created by Chase on 2021/5/21.
//

import SwiftUI

struct BombView: View {
    @EnvironmentObject var gameSettings: GameSettings
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.white)
                .opacity(0.3)
                .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
            Circle()
                .foregroundColor(Color.init(red: 0/255, green: 180/255, blue: 216/255))
                .opacity(0.3)
                .frame(width: UIScreen.main.bounds.width * 0.085, height: UIScreen.main.bounds.width * 0.085)
            Button(action: {
                gameSettings.ballBtn(row: gameSettings.game.playersLocation[gameSettings.myIndex].currentRow, col: gameSettings.game.playersLocation[gameSettings.myIndex].currentCol, power: gameSettings.game.players[gameSettings.myIndex].bombPower )
                
            }, label: {
                Image("bomb")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.09, height: UIScreen.main.bounds.width * 0.09)
                    .clipShape(Circle())
            }).offset(x: 3)
        }
    }
}

struct PropView: View {
    @EnvironmentObject var gameSettings: GameSettings
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.white)
                .opacity(0.3)
                .frame(width: UIScreen.main.bounds.width * 0.05, height: UIScreen.main.bounds.width * 0.05)
            Circle()
                .foregroundColor(Color.init(red: 0/255, green: 180/255, blue: 216/255))
                .opacity(0.3)
                .frame(width: UIScreen.main.bounds.width * 0.035, height: UIScreen.main.bounds.width * 0.035)
            Button(action: {
                gameSettings.savingPinBtn()
            }, label: {
                Image("savingpin")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.08)
                    .clipShape(Circle())
            }).offset(x: 3)
            //.disabled(gameSettings.game.players[gameSettings.myIndex].savingPinNum == 0 ? true : false)
        }
    }
}

