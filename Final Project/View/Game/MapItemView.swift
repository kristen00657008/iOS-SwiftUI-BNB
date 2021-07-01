//
//  MapItemView.swift
//  test
//
//  Created by Chase on 2021/5/21.
//

import SwiftUI

struct MapItemView: View {
    @EnvironmentObject var gameSettings: GameSettings
    var index = 0
    
    var body: some View {
        ZStack{
            Image("01")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.height * 0.075, height: UIScreen.main.bounds.height * 0.075)
                .zIndex(1)
            Image(gameSettings.game.mapItems[index].img)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.height * 0.075, height: UIScreen.main.bounds.height * 0.075)
                .zIndex(gameSettings.game.mapItems[index].state == 2 ? 3 : gameSettings.game.mapItems[index].img == "12" ? 5 : 2)
            
            Image("bomb_road")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.height * 0.075, height: UIScreen.main.bounds.height * 0.075)
                .opacity(gameSettings.game.mapItems[index].bombRoadOpacity)
                .rotationEffect(Angle(degrees: gameSettings.game.mapItems[index].bombRoadDegree))
                .zIndex(2)
            
            Image("bomb_center")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.height * 0.075, height: UIScreen.main.bounds.height * 0.075)
                .opacity(gameSettings.game.mapItems[index].bombCenterOpacity)
                .zIndex(2)
            
            ForEach(gameSettings.game.currentBombs) { bomb in
                if index == bomb.row * 15 + bomb.col {
                    GifView(gifName: "water_ball")
                        .frame(width: UIScreen.main.bounds.height * 0.15, height: UIScreen.main.bounds.height * 0.15)
                        .offset(y: -10)
                        .zIndex(3)
                }
            }
            
            ForEach(gameSettings.game.players) { player in
                if player.isLive {
                    if index == gameSettings.game.playersLocation[player.id].currentRow * 15 + gameSettings.game.playersLocation[player.id].currentCol {
                        ZStack{
                            Image(gameSettings.game.playersLocation[player.id].character)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.height * 0.17, height: UIScreen.main.bounds.height * 0.15)
                                .offset(y: UIScreen.main.bounds.height * -0.02)
                                
                            if player.isTrapped {
                                Circle()
                                    .fill(Color.init(red: 0/255, green: 166/255, blue: 251/255))
                                    .frame(width: UIScreen.main.bounds.height * 0.1, height: UIScreen.main.bounds.height * 0.1)
                                    .opacity(0.8)
                                    .zIndex(5)
                            }
                        }.zIndex(4)
                    }
                }
            }
        }.onTapGesture {
            print(index)
        }
    }
}

struct MapItemView_Previews: PreviewProvider {
    static var previews: some View {
        MapItemView()
    }
}
