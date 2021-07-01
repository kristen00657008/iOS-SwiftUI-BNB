//
//  JoystickView.swift
//  test
//
//  Created by Chase on 2021/5/21.
//

import SwiftUI

struct JoystickView: View {
    @EnvironmentObject var gameSettings: GameSettings
    let directions: [Direction] = [.right, .left, .down, .up]
    let degrees: [Double] = [-90, 90, 0, 180]
    let offsets: [CGSize] = [CGSize(width: 40, height: 0), CGSize(width: -40, height: 0), CGSize(width: 0, height: 40), CGSize(width: 0, height: -40)]
    var body: some View {
        ZStack{
            ForEach(0..<4) { index in
                DirectionBtnView(direction: directions[index], degree: degrees[index] ).offset(offsets[index]).environmentObject(gameSettings)
            }
        }
    }
}

struct DirectionBtnView: View {
    var direction: Direction
    var degree: Double
    @EnvironmentObject var gameSettings: GameSettings
    var body: some View {
        Button(action: {
            gameSettings.directionBtn(direction: direction)
        }, label: {
            Image("arrow")
                .resizable()
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: degree))
        })
    }
}

enum Direction: String{
    case up, down, left, right
}
