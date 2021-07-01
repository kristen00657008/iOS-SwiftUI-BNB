//
//  CreateIconView.swift
//  FinalProject-part2
//
//  Created by Chase on 2021/4/20.
//

import SwiftUI

struct CreateIconView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var icon_settings: Icon_Settings
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var current_part = 0
    @State private var current_index = 0
    @State private var current_left = 0
    @State private var current_right = 0
    var body: some View {
        ZStack{
            Color.init(red: 216/255, green: 243/255, blue: 220/255).edgesIgnoringSafeArea(.all)
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.blue)
                    .shadow(radius: 5)
                    .overlay(
                        Text("X")
                            .font(Font.system(size: 25))
                            .bold()
                            .foregroundColor(.white)
                    )
                
            }).position(x: appViewModel.width * 0.9, y: appViewModel.height * 0.1)
            
            CharacterView.position(x: appViewModel.width * 0.5, y:appViewModel.height * 0.25)
            VStack{
                Button(action: {
                    current_part = 0
                    current_index = icon_settings.current_head
                }, label: {
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .frame(width: 100, height: 50)
                        .overlay(
                            Text("頭部")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 50)
                        )
                })
                Button(action: {
                    current_part = 1
                    current_index = icon_settings.current_face
                }, label: {
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .frame(width: 100, height: 50)
                        .overlay(
                            Text("臉部")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 50)
                        )
                })
                Button(action: {
                    current_part = 2
                    current_index = icon_settings.current_body
                }, label: {
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .frame(width: 100, height: 50)
                        .overlay(
                            Text("身體")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(width: 150, height: 50)
                        )
                })
            }
            .frame(width: 150, height: appViewModel.height)
            .position(x: 100, y: appViewModel.height * 0.5)
            
            PickerView.position(x: appViewModel.width * 0.5, y: appViewModel.height * 0.88)
            
            Button(action: {
                let random_head = Int.random(in: 0..<46)
                let random_body = Int.random(in: 0..<30)
                let random_face = Int.random(in: 0..<30)
                icon_settings.current_head = random_head
                icon_settings.current_body = random_body
                icon_settings.current_face = random_face
            }, label: {
                Image("dice")
                    .resizable()
                    .frame(width: 50, height: 50)
            })
            .position(x: appViewModel.width * 0.3, y: appViewModel.height * 0.65)
            
            /*Button(action: {
                let image = CharacterView.snapshot()
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
            }, label: {
                Text("儲存至相簿")
            })
            .position(x: appViewModel.width * 0.75, y: appViewModel.height * 0.7)*/
            
            Button(action: {
                let image = CharacterView.snapshot()
                icon_settings.current_photo_Img = Image(uiImage: image)
                let old_photo_url = appViewModel.user.userInfo.imgUrl
                appViewModel.uploadPhoto(image: image) { result in
                    switch result {
                    case .success(let url):
                        appViewModel.setUserPhoto(id: appViewModel.user.id!, url: url)
                        appViewModel.user.userInfo.imgUrl = url.absoluteString
                        appViewModel.deleteOldPhoto(currentImgUrl: appViewModel.user.userInfo.imgUrl, url: old_photo_url)
                    case .failure(let error):
                        print(error)
                    }
                }
            }, label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 120, height: 50)
                    .foregroundColor(Color.gray)
                    .shadow(radius: 5)
                    .overlay(
                        Text("換頭像")
                            .font(Font.system(size: 25))
                            .foregroundColor(.white)
                    )
            })
            .position(x: appViewModel.width * 0.8, y: appViewModel.height * 0.65)
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.gray)
                .opacity(0.8)
                .frame(width: appViewModel.width * 0.9, height: 2)
                .position(x: appViewModel.width * 0.5, y: appViewModel.height * 0.73)
            
            Triangle()
                .fill(Color.gray)
                .opacity(0.8)
                .rotationEffect(Angle(degrees: 180))
                .frame(width: appViewModel.width * 0.02, height: appViewModel.width * 0.02)
                .position(x: appViewModel.width * 0.5, y: appViewModel.height * 0.75)
        }
    }
    
    var CharacterView: some View {
        ZStack{
            Image("body-\(icon_settings.current_body)")
                .resizable()
                .frame(width: 150, height: 130)
                .offset(x: -25,y: 122)
                
            Image("head-\(icon_settings.current_head)")
                .resizable()
                .frame(width: 170, height: 180)
            
            Image("face-\(icon_settings.current_face)")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(x: 10, y: 20)
        }
    }
    
    var PickerView: some View {
        HStack{
            ForEach(current_index - 3...current_index + 3, id:\.self) { index in
                Button(action: {
                    switch current_part {
                    case 0:
                        current_index = index < 0 ? index % 46 + 46: abs(index) % 46
                        icon_settings.current_head = current_index
                    case 1:
                        current_index = index < 0 ? index % 30 + 30: abs(index) % 30
                        if current_index < 3 {
                            current_left = 30 - (3 - current_index)
                        }
                        if current_index > 26 {
                            current_right = (30 - current_index)
                        }
                        icon_settings.current_face = current_index
                    case 2:
                        current_index = index < 0 ? index % 30 + 30: abs(index) % 30
                        if current_index < 3 {
                            current_left = 30 - (3 - current_index)
                        }
                        if current_index > 26 {
                            current_right = (30 - current_index)
                        }
                        icon_settings.current_body = current_index
                    default:
                        current_index = index < 0 ? index % 46 + 46: abs(index) % 46
                        icon_settings.current_head = current_index
                    }
                    print(current_index)
                }, label: {
                    switch current_part {
                    case 0:
                        Image("head-\(index < 0 ? 46 - abs(index) % 46 : abs(index) % 46)")
                            .resizable()
                            .frame(width: appViewModel.width * 0.11, height: appViewModel.width * 0.11)
                    case 1:
                        Image("face-\(index < 0 ? 30 - abs(index) % 46 : abs(index) % 30)")
                            .resizable()
                            .frame(width: appViewModel.width * 0.11, height: appViewModel.width * 0.11)
                    case 2:
                        Image("body-\(index < 0 ? 30 - abs(index) % 46 : abs(index) % 30)")
                            .resizable()
                            .frame(width: appViewModel.width * 0.11, height: appViewModel.width * 0.11)
                    default:
                        Image("head-\(abs(index) % 46)")
                            .resizable()
                            .frame(width: appViewModel.width * 0.11, height: appViewModel.width * 0.11)
                    }
                })
            }
        }
    }
    
}

