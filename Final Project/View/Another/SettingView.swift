//
//  SettingView.swift
//  Final Project
//
//  Created by Chase on 2021/6/23.
//

import SwiftUI
import AVFoundation

struct SettingView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @AppStorage("volume") var volume = 0.5
    @AppStorage("isMute") var isMuted: Bool = false
    var body: some View {
        ZStack{
            Color.init(red: 142/255, green: 202/255, blue: 230/255)
            VStack{
                HStack{
                    Text("音樂")
                        .font(Font.system(size: 25))
                    Image(systemName: isMuted ? "square" : "checkmark.square.fill")
                        .frame(width: 25, height: 25)
                        .foregroundColor(isMuted ? Color(UIColor.systemBlue) : Color.secondary)
                        .onTapGesture {
                            self.isMuted.toggle()
                            AVPlayer.queuePlayer.isMuted = self.isMuted
                        }
                    Slider(value: $volume, in: 0...1.0 ){_ in
                        AVPlayer.queuePlayer.volume = Float(volume)
                    }.frame(width: appViewModel.width * 0.5)
                    .disabled(self.isMuted ? true : false)
                }
                
            }
        }
        .frame(width: appViewModel.width * 0.7, height: appViewModel.height * 0.85)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.init(red: 2/255, green: 48/255, blue: 71/255), lineWidth: 8))
        .overlay(
            Button(action: {
                appViewModel.isSettingView = false
            }, label: {
                Image("close")
                    .resizable()
                    .frame(width: appViewModel.width * 0.05, height: appViewModel.width * 0.05)
            }).offset(x: appViewModel.width * 0.35, y: appViewModel.height * -0.42)
        )
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
