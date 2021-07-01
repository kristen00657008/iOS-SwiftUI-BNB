//
//  ProfileView.swift
//  FinalProject-part2
//
//  Created by Chase on 2021/4/20.
//

import SwiftUI
import AVFoundation

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var icon_settings: Icon_Settings
    @State private var isPresented = false
    @State private var showAlert = false
    @State private var showEditView = false
    @State private var nickname = ""
    @State private var selectedGender = ""
    @State private var birthday = Date()
    @State private var selectedConstellation = ""
    @State private var alerts: Alerts = .isLogOut
    @State private var editor: Editor = .nickname
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack{
            Color.init(red: 184/255, green: 231/255, blue: 232/255)
            
            ZStack{
                UserNameView
                    .position(x: appViewModel.width * 0.25, y: appViewModel.height * 0.2)
                
                UserInfoView
                    .position(x: appViewModel.width * 0.25, y: appViewModel.height * 0.6)
                
                ButtonView
                    .position(x: appViewModel.width * 0.5, y: appViewModel.height * 0.94)
                
                RecordView
                    .position(x: appViewModel.width * 0.75, y: appViewModel.height * 0.45)
                Button(action: {
                    appViewModel.view = "LobbyView"
                }, label: {
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.blue)
                        .shadow(radius: 5)
                        .overlay(
                            Text("X")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                        )
                }).position(x: appViewModel.width * 0.95, y: appViewModel.height * 0.05)
            }.disabled(showEditView)
            .opacity(showEditView ? 0.5 : 1.0)
            
            if showEditView {
                EditView
            }
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert) {
            switch alerts {
            case .isLogOut:
                return Alert(title: Text("確定要登出？"), message: Text(""), primaryButton: .default(Text("取消"), action: {
                    print("取消登出")
                }), secondaryButton: .default(Text("確定"), action: {
                    print("確定登出")
                    appViewModel.logOut()
                    appViewModel.user = User()
                    appViewModel.view = "HomepageView"
                    
                }))
                
            case .isDelete:
                return Alert(title: Text("確定要銷毀？"), message: Text(""), primaryButton: .default(Text("取消"), action: {
                    print("取消")
                }), secondaryButton: .default(Text("確定"), action: {
                    print("確定銷毀")
                    appViewModel.Delete_Auth()
                    appViewModel.Delete_User_Firestore(authId: appViewModel.user.authId)
                    appViewModel.deleteOldPhoto(currentImgUrl: appViewModel.user.userInfo.imgUrl, url: appViewModel.user.userInfo.imgUrl)
                    appViewModel.logOut()
                    appViewModel.user = User()
                    appViewModel.view = "HomepageView"
                }))
            }
        }
        .fullScreenCover(isPresented: $isPresented) {
            CreateIconView().environmentObject(icon_settings).environmentObject(appViewModel)
        }
    }
    
    var UserNameView: some View {
        HStack{
            Spacer()
            Button(action: {
                isPresented.toggle()
            }, label: {
                icon_settings.current_photo_Img
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 5)
                    )
                    .overlay(
                        Image("pencil")
                            .resizable()
                            .background(Color.white)
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                            .offset(x: -40, y: -45)
                    )
            }).offset(x: 15)
            VStack{
                Text(appViewModel.user.userInfo.nickname)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.1, alignment: .leading)
                    .background(Color.black)
                    .cornerRadius(5)
                    .overlay(
                        Button(action: {
                            editor = .nickname
                            showEditView = true
                        }, label: {
                            Image("pencil2")
                                .resizable()
                                .frame(width: 35, height: 35, alignment: .trailing)
                        }).offset(x: appViewModel.width * 0.12)
                    )
                Text("從\(appViewModel.user.userAccount.registrationTime, formatter: Self.taskDateFormat)開始遊玩")
                    .foregroundColor(.gray)
                    .font(Font.system(size: 20, weight: .bold))
                    .frame(width: appViewModel.width * 0.35, height: appViewModel.height * 0.1, alignment: .leading)
                    .offset(x: appViewModel.width * 0.02)
            }
            Spacer()
        }
    }
    
    var UserInfoView: some View {
        ZStack{
            VStack(spacing: 10){
                HStack(spacing: 0){
                    Text("性別")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(20)
                        .frame(width: appViewModel.width * 0.14, height: appViewModel.height * 0.1)
                        .background(RoundedCorners(tl: 5, tr: 0, bl: 5, br: 0).fill(Color.init(red: 0/255, green: 40/255, blue: 85/255)))
                    Text("\(appViewModel.user.userInfo.gender)")
                        .foregroundColor(.black)
                        .font(.title)
                        .padding(20)
                        .frame(width: appViewModel.width * 0.29, height: appViewModel.height * 0.1)
                        .background(RoundedCorners(tl: 0, tr: 5, bl: 0, br: 5).fill(Color.init(red: 240/255, green: 240/255, blue: 240/255)))
                    Button(action: {
                        editor = .gender
                        showEditView = true
                    }, label: {
                        Image("pencil")
                            .resizable()
                            .background(Color.white)
                            .clipShape(Circle())
                            .frame(width: 25, height: 25)
                    })
                    .offset(x: appViewModel.width * -0.02, y: appViewModel.height * -0.03)
                    .zIndex(2)
                }
                
                HStack(spacing: 0){
                    Text("星座")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(20)
                        .frame(width: appViewModel.width * 0.14, height: appViewModel.height * 0.1)
                        .background(RoundedCorners(tl: 5, tr: 0, bl: 5, br: 0).fill(Color.init(red: 0/255, green: 40/255, blue: 85/255)))
                    Text("\(appViewModel.user.userInfo.constellation)")
                        .foregroundColor(.black)
                        .font(.title)
                        .padding(20)
                        .frame(width: appViewModel.width * 0.29, height: appViewModel.height * 0.1)
                        .background(RoundedCorners(tl: 0, tr: 5, bl: 0, br: 5).fill(Color.init(red: 240/255, green: 240/255, blue: 240/255)))
                    Button(action: {
                        editor = .constellations
                        showEditView = true
                    }, label: {
                        Image("pencil")
                            .resizable()
                            .background(Color.white)
                            .clipShape(Circle())
                            .frame(width: 25, height: 25)
                    })
                    .offset(x: appViewModel.width * -0.02, y: appViewModel.height * -0.03)
                    .zIndex(2)
                }
                
                HStack(spacing: 0){
                    Text("生日")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(20)
                        .frame(width: appViewModel.width * 0.14, height: appViewModel.height * 0.1)
                        .background(RoundedCorners(tl: 5, tr: 0, bl: 5, br: 0).fill(Color.init(red: 0/255, green: 40/255, blue: 85/255)))
                    Text("\(appViewModel.user.userInfo.birthday, formatter: Self.taskDateFormat)")
                        .foregroundColor(.black)
                        .font(.title)
                        .padding(20)
                        .frame(width: appViewModel.width * 0.29, height: appViewModel.height * 0.1)
                        .background(RoundedCorners(tl: 0, tr: 5, bl: 0, br: 5).fill(Color.init(red: 240/255, green: 240/255, blue: 240/255)))
                    Button(action: {
                        editor = .birthday
                        showEditView = true
                    }, label: {
                        Image("pencil")
                            .resizable()
                            .background(Color.white)
                            .clipShape(Circle())
                            .frame(width: 25, height: 25)
                    })
                    .offset(x: appViewModel.width * -0.02, y: appViewModel.height * -0.03)
                    .zIndex(2)
                }
            }.offset(x: 10)
        }.frame(width: appViewModel.width * 0.45, height: appViewModel.height * 0.5)
        .background(Color.init(red: 120/255, green: 213/255, blue: 215/255))
        .cornerRadius(15)
    }
    
    var EditView: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.black)
                .frame(width: appViewModel.width * 0.45, height: appViewModel.height * 0.5)
                .overlay(VStack(spacing: 0){
                    Text("更改\(getEditor(editor: editor)!)")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(20)
                        .frame(width: appViewModel.width * 0.445, height: appViewModel.height * 0.1)
                        .background(RoundedCorners(tl: 15, tr: 15, bl: 0, br: 0).fill(Color.init(red: 0/255, green: 40/255, blue: 85/255)))
                    
                    Rectangle()
                        .frame(width: appViewModel.width * 0.445, height: appViewModel.height * 0.245)
                        .foregroundColor(Color.init(red: 255/255, green: 253/255, blue: 247/255))
                        .overlay(HStack{
                            Spacer()
                            Text("\(getEditor(editor: editor)!) : ")
                                .foregroundColor(.black)
                                .font(.title)
                            switch editor {
                            case .nickname:
                                TextField("請輸入名稱", text: $nickname)
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: appViewModel.width * 0.3, height: appViewModel.height * 0.1).font(.largeTitle)
                            case .birthday:
                                DatePicker("", selection: $birthday, displayedComponents: .date)
                                    .frame(width: appViewModel.width * 0.1, height: appViewModel.height * 0.1)
                            case .gender:
                                Picker(selection: $selectedGender, label: Text("選擇性別")) {
                                    ForEach(genders, id: \.self) { (gender) in
                                        Text(gender)
                                    }
                                }.frame(width: appViewModel.width * 0.2, height: appViewModel.height * 0.1)
                                .shadow(radius: 50)
                                .pickerStyle(SegmentedPickerStyle())
                                .onAppear{
                                    UISegmentedControl.appearance().selectedSegmentTintColor = .gray
                                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
                                }
                            case .constellations:
                                Picker(selection: $selectedConstellation, label: Text("選擇星座")) {
                                    ForEach(constellations, id: \.self) { (constellation) in
                                        Text(constellation).foregroundColor(.black)
                                    }
                                }.frame(width: appViewModel.width * 0.2, height: appViewModel.height * 0.2)
                                .clipped()
                                .shadow(radius: 30)
                                .foregroundColor(.black)
                            }
                            Spacer()
                        })
                    ZStack{
                        Button(action: {
                            switch editor {
                            case .nickname:
                                appViewModel.user.userInfo.nickname = nickname
                                print(appViewModel.user.userInfo.nickname)
                            case .birthday:
                                appViewModel.user.userInfo.birthday = birthday
                                print(appViewModel.user.userInfo.birthday)
                            case .gender:
                                appViewModel.user.userInfo.gender = selectedGender
                                print(appViewModel.user.userInfo.gender)
                            case .constellations:
                                appViewModel.user.userInfo.constellation = selectedConstellation
                                print(appViewModel.user.userInfo.constellation)
                            }
                            appViewModel.updateUserInfo(user: appViewModel.user)
                            showEditView = false
                        }, label: {
                            Capsule()
                                .frame(width: appViewModel.width * 0.14, height: appViewModel.height * 0.1)
                                .foregroundColor(Color.gray)
                                .shadow(radius: 50)
                                .overlay(Text("變更")
                                            .foregroundColor(Color.white)
                                            .font(.title))
                        })
                    }
                    .frame(width: appViewModel.width * 0.445, height: appViewModel.height * 0.145)
                    .background(RoundedCorners(tl: 0, tr: 0, bl: 15, br: 15).fill(Color.init(red: 235/255, green: 235/255, blue: 235/255)))
                })
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
                .offset(x: appViewModel.width * 0.22, y: appViewModel.height * -0.25)
                .onTapGesture {
                    showEditView = false
                }
        }.frame(width: appViewModel.width * 0.45, height: appViewModel.height * 0.5)
        
    }
    
    var ButtonView: some View {
        ZStack{
            Rectangle()
                .frame(width: appViewModel.width * 1.5, height: appViewModel.height * 0.15)
                .foregroundColor(Color.init(red: 0/255, green: 40/255, blue: 85/255))
                .overlay(
                    HStack(spacing: 20){
                        Button(action: {
                            showAlert = true
                            alerts = .isLogOut
                        }, label: {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: appViewModel.width * 0.2, height: appViewModel.height * 0.08)
                                .foregroundColor(Color.gray)
                                .shadow(radius: 5)
                                .overlay(
                                    Text("登出")
                                        .font(Font.system(size: 25))
                                        .foregroundColor(.white)
                                )
                        })
                        
                        Button(action: {
                            showAlert = true
                            alerts = .isDelete
                        }, label: {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: appViewModel.width * 0.2, height: appViewModel.height * 0.08)
                                .foregroundColor(Color.gray)
                                .shadow(radius: 5)
                                .overlay(
                                    Text("帳號銷毀")
                                        .font(Font.system(size: 25))
                                        .foregroundColor(.white)
                                )
                        })
                    }.offset(y: appViewModel.height * -0.02)
                )
        }
    }
    
    var RecordView: some View {
        ZStack{
            VStack(spacing: 0){
                Text("對戰戰績")
                    .font(.title)
                    .foregroundColor(.black)
                    .frame(width: appViewModel.width * 0.4, height: appViewModel.height * 0.1)
                HStack{
                    Spacer()
                    Text("結果")
                        .foregroundColor(.white)
                        .frame(width: appViewModel.width * 0.1, height: appViewModel.height * 0.05)
                    Spacer()
                    Text("名次")
                        .foregroundColor(.white)
                        .frame(width: appViewModel.width * 0.1, height: appViewModel.height * 0.05)
                    Spacer()
                    Text("對戰模式")
                        .foregroundColor(.white)
                        .frame(width: appViewModel.width * 0.1, height: appViewModel.height * 0.05)
                    Spacer()
                }
                .frame(width: appViewModel.width * 0.4, height: appViewModel.height * 0.05)
                .background(Color.init(red: 38/255, green: 97/255, blue: 156/255))
                ScrollView {
                    VStack{
                        ForEach(appViewModel.user.records, id:  \.id){ (record) in
                            RecordRowView(record: record)
                        }
                    }
                }.background(Color.init(red: 152/255, green: 210/255, blue: 231/255))
                
            }
            
            
        }
        .frame(width: appViewModel.width * 0.4, height: appViewModel.height * 0.75)
        .background(Color.init(red: 152/255, green: 210/255, blue: 231/255))
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.init(red: 38/255, green: 97/255, blue: 156/255), lineWidth: 1)
        )
        .cornerRadius(25)
    }
    
    func getEditor(editor: Editor) -> String? {
        if editor == .nickname {
            return "名稱"
        }
        else if editor == .gender {
            return "性別"
        }
        else if editor == .constellations {
            return "星座"
        }
        else if editor == .birthday {
            return "生日"
        }
        else {
            return ""
        }
    }
    
}

struct RecordRowView: View {
    var record: Record
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("\(record.result)")
                    .foregroundColor(Color.init(red: 32/255, green: 32/255, blue: 32/255))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.1)
                Spacer()
                Text("\(record.rank)")
                    .foregroundColor(Color.init(red: 51/255, green: 53/255, blue: 51/255))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.1)
                Spacer()
                Text("\(record.mode)")
                    .foregroundColor(Color.init(red: 51/255, green: 53/255, blue: 51/255))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.1)
                Spacer()
            }.offset(y: 10)
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.4, height: 2)
                .foregroundColor(Color.init(red: 38/255, green: 97/255, blue: 156/255))
        }.frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.1)
        
    }
}

