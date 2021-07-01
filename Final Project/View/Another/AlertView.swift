//
//  AlertView.swift
//  Final Project
//
//  Created by Chase on 2021/4/23.
//

import SwiftUI

struct AlertView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.gray)
            .overlay(Text(appViewModel.alert_msg).foregroundColor(.white).font(Font.system(size: 20)))
            .frame(width: 230, height: 80)
            .opacity(appViewModel.alert_opacity)
            .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.45)
    }
}
