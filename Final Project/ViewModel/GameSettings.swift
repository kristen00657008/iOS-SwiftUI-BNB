//
//  GameSettings.swift
//  Final Project
//
//  Created by Chase on 2021/5/12.
//

import SwiftUI
import AVFoundation

class GameSettings: FirebaseViewModel, ObservableObject {
    @Published var room: Room = Room()
    @Published var game: Game = Game(userNum: 1)
    @Published var enterCode = ""
    @Published var myIndex = 0
    var myId = ""
    
    func createRoomBtn(user: UserInfo, completion: @escaping () -> Void) {
        self.room = Room()
        self.myId = UUID().uuidString
        self.myIndex = 0
        self.room.users.append(UserInRoom(id: myId, gender: user.gender, imgUrl: user.imgUrl, nickname: user.nickname, isHost: true))
        createRoom(room: self.room) { room in
            self.room = room
            print(self.room.id!)
            completion()
        }
    }
    
    func joinRoomBtn(user: UserInfo, completion: @escaping (Bool) -> Void) {
        isRoomExist(invitationCode: self.enterCode) { [self] (result, room) in
            switch result {
            case true:
                self.room = room
                self.myId = UUID().uuidString
                self.myIndex = self.room.users.count
                self.room.users.append(UserInRoom(id: self.myId, gender: user.gender, imgUrl: user.imgUrl, nickname: user.nickname, isHost: false))
                updateRoomUsers(id: room.id!, roomUsersDictionary: roomUsersToDictionary())
                completion(true)
            case false:
                completion(false)
            }
        }
    }
    
    func deleteUser() {
        room.users.remove(at: self.myIndex)
        updateRoomUsers(id: self.room.id!, roomUsersDictionary: roomUsersToDictionary())
    }
    
    func ExitRoomBtn() {
        if self.room.users[myIndex].isHost {
            deleteRoom(id: self.room.id!)
        }
        else {
            deleteUser()
        }
    }
    
    func roomBtn() -> String {
        if self.room.users[myIndex].isHost {
            return startGameBtn().rawValue
        }
        else {
            readyBtn()
            return ""
        }
    }
    
    func readyBtn() {
        self.room.users[myIndex].isReady.toggle()
        updateRoomUsers(id: self.room.id!, roomUsersDictionary: roomUsersToDictionary())
    }
    
    func startGameBtn() -> StartGameSituation {
        if self.room.users.count <= 1 {
            print("人數不足")
            return .underRepresented
        }
        
        for user in self.room.users {
            if !user.isHost {
                if user.isReady == false {
                    return .notAllReady
                }
            }
        }
        print("遊戲開始")
        createGame(userNum: self.room.users.count) { [self] game in
            room.GameID = game.id!
            room.isPlaying = true
            updateRoom(id: room.id!, isPlaying: room.isPlaying, gameID: room.GameID)
        }
        return .gameStart
    }
    
    func ballBtn(row: Int, col: Int, power: Int) {
        if self.game.players[myIndex].isTrapped {
            return
        }
        if self.game.players[myIndex].currentBombsNum + 1 <= self.game.players[myIndex].bombNum {
            if !self.game.currentBombs.contains(where: { (bomb) -> Bool in
                if bomb.col == col && bomb.row == row{
                    return true
                }
                else {
                    return false
                }
            }) {
                self.game.players[myIndex].currentBombsNum += 1
                self.game.currentBombs.append(Bomb(id: self.game.currentBombs.count, row: row, col: col, power: power))
                updatePlayers(id: self.room.GameID, playersDictionary: playersToDictionary())
                updateBombs(id: self.room.GameID, currentBombsDictionary: currentBombsToDictionary())
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){ [self] in
                    print("ball bombed")
                    ballBombed(row: row, col: col, power: power)
                }
            }
        }
        
    }
    
    func ballBombed(row: Int, col: Int, power: Int){
        let itemIndex = row * 15 + col
        if !self.game.currentBombs.contains(where: { (bomb) -> Bool in
            if bomb.col == col && bomb.row == row{
                return true
            }
            else {
                return false
            }
        }) {
            print("此水球不存在了\(row),\(col)")
            return
        }
        AVPlayer.bombedPlayer.playFromStart()
        self.game.currentBombs.remove(at: findBombIndex(row: row, col: col))
        var bombRoads: [BombRoad] = []
        bombRoads.append(contentsOf: upBombJudge(row: row, col: col, power: power))
        bombRoads.append(contentsOf: downBombJudge(row: row, col: col, power: power))
        bombRoads.append(contentsOf: leftBombJudge(row: row, col: col, power: power))
        bombRoads.append(contentsOf: rightBombJudge(row: row, col: col, power: power))
        self.game.players[myIndex].currentBombsNum -= 1
        self.game.mapItems[itemIndex].bombCenterOpacity = 1
        
        for bombRoad in bombRoads {
            let bombRoadIndex = bombRoad.row * 15 + bombRoad.col
            self.game.mapItems[bombRoadIndex].bombRoadOpacity = 1
            if bombRoad.direction == 0 {
                self.game.mapItems[bombRoadIndex].bombRoadDegree = 0
            }
            else {
                self.game.mapItems[bombRoadIndex].bombRoadDegree = 90
            }
        }
        bombRoads.append(BombRoad(row: row, col: col, direction: 0))  // ＋中心
        isPlayersTrapped(bombRoads: bombRoads)
        updateBombs(id: self.room.GameID, currentBombsDictionary: currentBombsToDictionary())
        updatePlayers(id: self.room.GameID, playersDictionary: playersToDictionary())
        updateMapItems(id: self.room.GameID, mapItemsDictionary: mapItemsToDictionary())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            game.mapItems[itemIndex].bombCenterOpacity = 0
            for bombRoad in bombRoads {
                let bombRoadIndex = bombRoad.row * 15 + bombRoad.col
                game.mapItems[bombRoadIndex].bombRoadOpacity = 0
            }
            updateMapItems(id: room.GameID, mapItemsDictionary: mapItemsToDictionary())
        }
    }
    
    func upBombJudge(row: Int, col: Int, power: Int) -> [BombRoad] {
        var tempRow = row
        var count = 0
        var bombRoads: [BombRoad] = []
        while true {
            tempRow -= 1
            count += 1
            if count <= power {
                if tempRow >= 0 {
                    bombRoads.append(BombRoad(row: tempRow, col: col, direction: 1))
                    if isBomb(row: tempRow, col: col, power: power) {
                        print("附近有水球")
                    }
                    if judgeCurrentItem(row: tempRow, col: col) {
                        break
                    }
                }
            }
            else {
                break
            }
        }
        return bombRoads
    }
    
    func downBombJudge(row: Int, col: Int, power: Int) -> [BombRoad] {
        var tempRow = row
        var count = 0
        var bombRoads: [BombRoad] = []
        while true {
            tempRow += 1
            count += 1
            if count <= power {
                if tempRow <= 12 {
                    bombRoads.append(BombRoad(row: tempRow, col: col, direction: 1))
                    if isBomb(row: tempRow, col: col, power: power) {
                        print("附近有水球")
                    }
                    if judgeCurrentItem(row: tempRow, col: col) {
                        break
                    }
                }
            }
            else {
                break
            }
        }
        return bombRoads
    }
    
    func leftBombJudge(row: Int, col: Int, power: Int) -> [BombRoad] {
        var tempCol = col
        var count = 0
        var bombRoads: [BombRoad] = []
        while true {
            tempCol -= 1
            count += 1
            if count <= power{
                if tempCol >= 0 {
                    bombRoads.append(BombRoad(row: row, col: tempCol, direction: 0))
                    if isBomb(row: row, col: tempCol, power: power) {
                        print("附近有水球")
                    }
                    if judgeCurrentItem(row: row, col: tempCol) {
                        break
                    }
                }
            }
            else {
                break
            }
        }
        return bombRoads
    }
    
    func rightBombJudge(row: Int, col: Int, power: Int) -> [BombRoad] {
        var tempCol = col
        var count = 0
        var bombRoads: [BombRoad] = []
        while true {
            tempCol += 1
            count += 1
            if count <= power {
                if tempCol <= 14 {
                    bombRoads.append(BombRoad(row: row, col: tempCol, direction: 0))
                    if isBomb(row: row, col: tempCol, power: power) {
                        print("附近有水球")
                    }
                    if judgeCurrentItem(row: row, col: tempCol) {
                        break
                    }
                }
            }
            else {
                break
            }
        }
        return bombRoads
    }
    
    func judgeCurrentItem(row: Int, col: Int) ->Bool { //true: 水柱停止點
        let itemIndex = row * 15 + col
        if itemIndex > 194 {
            return false
        }
        if self.game.mapItems[itemIndex].state == 2 {
            return true
        }
        if self.game.mapItems[itemIndex].state == 1 {
            self.game.mapItems[itemIndex].state = 0
            self.game.mapItems[itemIndex].img = self.game.mapItems[itemIndex].originImage
            return true
        }
        if self.game.mapItems[itemIndex].state == 0 {
            self.game.mapItems[itemIndex].img = self.game.mapItems[itemIndex].originImage
            return false
        }
        return false
    }
    
    func isBomb(row: Int, col: Int, power: Int) ->Bool { //true: 水柱停止點
        let itemIndex = row * 15 + col
        if itemIndex > 165 {
            return false
        }
        
        if self.game.currentBombs.contains(where: { (bomb) -> Bool in
            if bomb.col == col && bomb.row == row{
                return true
            }
            else {
                return false
            }
        }) {
            findBomb(row: row, col: col, power: power)
            return true
        }
        return false
    }
    
    func findBomb(row: Int, col: Int, power: Int) {
        var count = 0
        for bomb in self.game.currentBombs {
            if bomb.row == row && bomb.col == col {
                ballBombed(row: row, col: col, power: power)
                break
            }
            count+=1
        }
    }
    
    func roomUsersToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for user in self.room.users {
            resultDictionary.append(user.dictionary)
        }
        return resultDictionary
    }
    
    func playersToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for player in self.game.players {
            resultDictionary.append(player.dictionary)
        }
        return resultDictionary
    }
    
    func playersLocationToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for playerLocation in self.game.playersLocation {
            resultDictionary.append(playerLocation.dictionary)
        }
        return resultDictionary
    }
    
    func currentBombsToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for bomb in self.game.currentBombs {
            resultDictionary.append(bomb.dictionary)
        }
        return resultDictionary
    }
    
    func mapItemsToDictionary() -> [Dictionary<String, Any>] {
        var resultDictionary: [Dictionary<String, Any>] = []
        for mapItem in self.game.mapItems {
            resultDictionary.append(mapItem.dictionary)
        }
        return resultDictionary
    }
    
    
    
    func directionBtn(direction: Direction) {
        let oldIndex = self.game.playersLocation[myIndex].currentRow * 15 + self.game.playersLocation[myIndex].currentCol
        
        if self.game.players[myIndex].isTrapped == true {
            switch  direction {
            case .up:
                self.game.playersLocation[myIndex].character = "Bazzi-3"
            case .down:
                self.game.playersLocation[myIndex].character = "Bazzi-1"
            case .left:
                self.game.playersLocation[myIndex].character = "Bazzi-4"
            case .right:
                self.game.playersLocation[myIndex].character = "Bazzi-2"
            }
            updatePlayersLocation(id: self.room.GameID, playersLocationDictionary: playersLocationToDictionary())
            return
        }
        
        switch  direction {
        case .up:
            self.game.playersLocation[myIndex].character = "Bazzi-3"
            if self.game.playersLocation[myIndex].currentRow - 1 >= 0 {
                if self.game.mapItems[oldIndex - 15].state == 0 {
                    if !self.game.currentBombs.contains(where: { (bomb) -> Bool in
                        if bomb.row ==  self.game.playersLocation[myIndex].currentRow - 1 && bomb.col == self.game.playersLocation[myIndex].currentCol {
                            return true
                        }
                        else {
                            return false
                        }
                    }) {
                        self.game.playersLocation[myIndex].currentRow -= 1
                    }
                }
            }
        case .down:
            self.game.playersLocation[myIndex].character = "Bazzi-1"
            if self.game.playersLocation[myIndex].currentRow + 1 <= 12 {
                if self.game.mapItems[oldIndex + 15].state == 0{
                    if !self.game.currentBombs.contains(where: { (bomb) -> Bool in
                        if bomb.row ==  self.game.playersLocation[myIndex].currentRow + 1 && bomb.col == self.game.playersLocation[myIndex].currentCol {
                            return true
                        }
                        else {
                            return false
                        }
                    }) {
                        self.game.playersLocation[myIndex].currentRow += 1
                    }
                }
            }
        case .left:
            self.game.playersLocation[myIndex].character = "Bazzi-4"
            if self.game.playersLocation[myIndex].currentCol - 1 >= 0 {
                if self.game.mapItems[oldIndex - 1].state == 0{
                    if !self.game.currentBombs.contains(where: { (bomb) -> Bool in
                        if bomb.row ==  self.game.playersLocation[myIndex].currentRow && bomb.col == self.game.playersLocation[myIndex].currentCol - 1 {
                            return true
                        }
                        else {
                            return false
                        }
                    }) {
                        self.game.playersLocation[myIndex].currentCol -= 1
                    }
                }
            }
        case .right:
            self.game.playersLocation[myIndex].character = "Bazzi-2"
            if self.game.playersLocation[myIndex].currentCol + 1 <= 14 {
                if self.game.mapItems[oldIndex + 1].state == 0{
                    if !self.game.currentBombs.contains(where: { (bomb) -> Bool in
                        if bomb.row ==  self.game.playersLocation[myIndex].currentRow && bomb.col == self.game.playersLocation[myIndex].currentCol + 1 {
                            return true
                        }
                        else {
                            return false
                        }
                    }) {
                        self.game.playersLocation[myIndex].currentCol += 1
                    }
                }
            }
        }
        updatePlayersLocation(id: self.room.GameID, playersLocationDictionary: playersLocationToDictionary())
    }
    
    func findBombIndex(row: Int, col: Int) -> Int{
        var result = 0
        
        for bomb in self.game.currentBombs {
            if row == bomb.row && col == bomb.col{
                break
            }
            result += 1
        }
        return result
    }
    
    
    func isPlayersTrapped(bombRoads: [BombRoad]){
        var resultPlayersID: [Int] = []
        for bombRoad in bombRoads {
            for player in self.game.players {
                if !player.isTrapped {
                    if self.game.playersLocation[player.id].currentRow == bombRoad.row && self.game.playersLocation[player.id].currentCol == bombRoad.col {
                        resultPlayersID.append(player.id)
                    }
                }
            }
        }
        for id in resultPlayersID {
            self.game.players[id].isTrapped = true
            if id == myIndex {
                AVPlayer.trapPlayer.playFromStart()
            }
            updatePlayers(id: self.room.GameID, playersDictionary: playersToDictionary())
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
                if self.game.players[id].isTrapped {
                    self.game.players[id].isLive = false
                    
                    if !self.judgeGameResult() {
                        self.updatePlayers(id: self.room.GameID, playersDictionary: self.playersToDictionary())
                    }
                }
            }
        }
    }
    
    func savingPinBtn() {
        if self.game.players[myIndex].isLive {
            if self.game.players[myIndex].isTrapped {
                if self.game.players[myIndex].savingPinNum > 0 {
                    self.game.players[myIndex].isTrapped = false
                    self.game.players[myIndex].savingPinNum -= 1
                    updatePlayers(id: self.room.GameID, playersDictionary: playersToDictionary())
                }
            }
        }
    }
    
    func judgeGameResult() -> Bool {
        let aliveCount = self.game.players.filter { $0.isLive }.count
        let winner = self.game.players.firstIndex(where: { $0.isLive })
        if aliveCount == 1 {
            self.game.players[winner!].winning = true
            self.game.isGameOver = true
            self.updatePlayers(id: self.room.GameID, playersDictionary: self.playersToDictionary())
            updateGameOver(id: self.room.GameID, isGameOver: self.game.isGameOver)
            return true
        }
        return false
    }
}


enum StartGameSituation: String {
    case notAllReady = "有玩家尚未準備"
    case underRepresented = "遊玩人數需大於 1 人"
    case gameStart = "遊戲即將開始"
    
}
