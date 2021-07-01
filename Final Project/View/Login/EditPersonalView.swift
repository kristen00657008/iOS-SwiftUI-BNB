//
//  NameView.swift
//  Final Project
//
//  Created by Chase on 2021/4/20.
//

import SwiftUI

struct EditPersonalView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var nickname = ""
    @State private var selectedGender = ""
    @State private var birthday = Date()
    @State private var selectedConstellation = ""
    @State private var selectedCountry = "請選擇國家 >"
    @State private var hide_confirm = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Image("background")
            .resizable()
            .edgesIgnoringSafeArea(.all)
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .frame(width: appViewModel.width * 0.5, height: appViewModel.height * 0.9)
                .overlay(VStack(spacing: 0){
                    Text("編輯個人資料")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(20)
                        .frame(width: appViewModel.width * 0.495, height: appViewModel.height * 0.14)
                        .background(RoundedCorners(tl: 15, tr: 15, bl: 0, br: 0).fill(Color.init(red: 0/255, green: 40/255, blue: 85/255)))
                    
                    Rectangle()
                        .frame(width: appViewModel.width * 0.495, height: appViewModel.height * 0.6)
                        .foregroundColor(Color.init(red: 255/255, green: 253/255, blue: 247/255))
                        .overlay(
                            NavigationView {
                                ScrollView {
                                    VStack{
                                        HStack{
                                            Spacer()
                                            Text("名稱 : ")
                                                .font(.title)
                                                .foregroundColor(.black)
                                            TextField("請輸入名稱", text: $nickname)
                                                .foregroundColor(.black)
                                                .font(.title)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.1).font(.largeTitle)
                                            Spacer()
                                        }
                                        HStack{
                                            Spacer()
                                            Text("生日 : ")
                                                .foregroundColor(.black)
                                                .font(.title)
                                            DatePicker("", selection: $birthday, displayedComponents: .date)
                                                .frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.1)
                                                .font(.title)
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            Spacer()
                                            Text("性別 : ")
                                                .foregroundColor(.black)
                                                .font(.title)
                                            Picker(selection: $selectedGender, label: Text("選擇性別")) {
                                                ForEach(genders, id: \.self) { (gender) in
                                                    Text(gender).foregroundColor(.black)
                                                }
                                            }.frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.1)
                                            .shadow(radius: 30)
                                            .pickerStyle(SegmentedPickerStyle())
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            Spacer()
                                            Text("星座 : ")
                                                .foregroundColor(.black)
                                                .font(.title)
                                            Picker(selection: $selectedConstellation, label: Text("選擇星座")) {
                                                ForEach(constellations, id: \.self) { (constellation) in
                                                    Text(constellation)
                                                }
                                            }.frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.2)
                                            .clipped()
                                            .shadow(radius: 30)
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            Spacer()
                                            Text("國家 : ")
                                                .foregroundColor(.black)
                                                .font(.title)
                                            NavigationLink(destination: SelectCountryView(selectedCountry: $selectedCountry, hide_confirm: $hide_confirm)) {
                                                Text("\(selectedCountry)")
                                                    .font(.largeTitle)
                                                    .foregroundColor(.gray)
                                                    .frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.2)
                                            }
                                            Spacer()
                                        }
                                    }
                                }.background(Color.white)
                                .navigationBarHidden(true).navigationBarBackButtonHidden(true)
                            }.environment(\.horizontalSizeClass, .compact)
                            
                        )
                    ZStack{
                        Button(action: {
                            appViewModel.user.userInfo = UserInfo(birthday: Date(), constellation: selectedConstellation, gender: selectedGender, imgUrl: "", nickname: nickname)
                            appViewModel.updateUserInfo(user: appViewModel.user)
                            appViewModel.view = "StartView"
                        }, label: {
                            Capsule()
                                .frame(width: appViewModel.width * 0.14, height: appViewModel.height * 0.1)
                                .foregroundColor(Color.gray)
                                .shadow(radius: 50)
                                .overlay(Text("確認")
                                            .foregroundColor(Color.white)
                                            .font(.title))
                        }).opacity(hide_confirm ? 0.0 : 1.0)
                        .disabled(hide_confirm ? true : false)
                    }
                    .frame(width: appViewModel.width * 0.495, height: appViewModel.height * 0.15)
                    .background(
                        RoundedCorners(tl: 0, tr: 0, bl: 15, br: 15)
                            .fill(hide_confirm ? Color.init(red: 255/255, green: 253/255, blue: 247/255) : Color.init(red: 235/255, green: 235/255, blue: 235/255))
                    )
                })
        }.frame(width: appViewModel.width * 0.5, height: appViewModel.height * 0.9).edgesIgnoringSafeArea(.all)
    }
    
}

struct SelectCountryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selectedCountry: String
    @Binding var hide_confirm: Bool
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            hide_confirm = false
        }) {
            Text("Go back")
        }
    }
    var body: some View {
        Picker(selection: $selectedCountry, label: Text("")) {
            ForEach(country_list, id: \.self) { (country) in
                Text(country).foregroundColor(.black)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .shadow(radius: 30)
        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.7)
        .onAppear{
            hide_confirm = true
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}
