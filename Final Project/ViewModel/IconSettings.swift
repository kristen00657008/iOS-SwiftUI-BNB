//
//  IconSettings.swift
//  Final Project
//
//  Created by Chase on 2021/5/15.
//

import Foundation
import SwiftUI

class Icon_Settings: ObservableObject {
    @Published var current_head = 0
    @Published var current_body = 0
    @Published var current_face = 0
    @Published var current_photo_str = ""
    @Published var current_photo_uiImg: UIImage = UIImage()
    @Published var current_photo_Img: Image = Image("01")
    @Published var current_photo_url = ""
}
