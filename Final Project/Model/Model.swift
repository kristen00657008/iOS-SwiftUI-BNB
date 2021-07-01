//
//  Model.swift
//  Final Project
//
//  Created by Chase on 2021/5/15.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct User:Codable, Identifiable {
    @DocumentID var id: String?
    var userAccount: UserAccount
    var userInfo: UserInfo
    var authId: String
    var records: [Record]
    
    init() {
        self.userInfo = UserInfo()
        self.userAccount = UserAccount()
        self.authId = ""
        self.records = []
    }
}

struct UserAccount: Codable {
    var email: String = ""
    var password: String = ""
    var loginWay: String = ""
    var registrationTime: Date = Date()
    
    var dictionary: [String: Any] {
        return ["email": self.email,
                "password": self.password,
                "loginWay": self.loginWay,
                "registrationTime": self.registrationTime]
    }
}

struct UserInfo: Codable {
    var birthday: Date = Date()
    var constellation: String = ""
    var gender: String = ""
    var imgUrl: String = ""
    var nickname: String = ""
    
    var dictionary: [String: Any] {
        return ["birthday": self.birthday,
                "constellation": self.constellation,
                "gender": self.gender,
                "imgUrl": self.imgUrl,
                "nickname": self.nickname]
    }
}

struct UserInRoom: Codable, Identifiable {
    var id: String
    var gender: String = ""
    var imgUrl: String = ""
    var nickname: String = ""
    var isHost: Bool
    var isReady: Bool = false
    
    init(id: String , gender: String, imgUrl: String, nickname: String, isHost: Bool) {
        self.id = id
        self.gender = gender
        self.imgUrl = imgUrl
        self.nickname = nickname
        self.isHost = isHost
    }
    
    var dictionary: [String: Any] {
        return ["id": self.id,
                "gender": self.gender,
                "imgUrl": self.imgUrl,
                "nickname": self.nickname,
                "isHost": self.isHost,
                "isReady": self.isReady]
    }
}

struct Room: Codable, Identifiable {
    @DocumentID var id: String?
    var users: [UserInRoom] = []
    var invitationCode: String = ""
    var isPlaying: Bool = false
    var GameID: String = ""
    
    init() {
        self.invitationCode = generateCode()
    }
    
    func generateCode() -> String {
        return String(Int.random(in: 10000..<99999))
    }
}

struct Record: Identifiable, Codable {
    var id: Int
    var result: String
    var rank: Int
    var mode: String
    
    var dictionary: [String: Any] {
        return ["id": self.id,
                "result": self.result,
                "rank": self.rank,
                "mode": self.mode]
    }
}

struct MyRectangle: Codable, Identifiable  {
    var id: String
    var width: Double
    var height: Double
    var index: Int
}
