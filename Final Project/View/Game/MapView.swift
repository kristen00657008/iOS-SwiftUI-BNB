//
//  MapView.swift
//  test
//
//  Created by Chase on 2021/5/21.
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject var gameSettings: GameSettings
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                ForEach(0..<13){ row in
                    HStack(spacing: 0){
                        ForEach(0..<15){ col in
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.height * 0.075, height: UIScreen.main.bounds.height * 0.075)
                                .overlay(
                                    MapItemView(index: row * 15 + col).environmentObject(gameSettings)
                                )
                        }
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.57, height: UIScreen.main.bounds.height)
        .background(Color.init(red: 165/255, green: 148/255, blue: 249/255))
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
