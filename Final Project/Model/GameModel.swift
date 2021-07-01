//
//  GameModel.swift
//  Final Project
//
//  Created by Chase on 2021/5/26.
//

import FirebaseFirestoreSwift
import SwiftUI

struct Game: Codable, Identifiable {
    @DocumentID var id: String?
    var userNum: Int
    var players: [Player]
    var playersLocation: [PlayerLocation]
    var mapItems: [MapItem]
    var currentBombs: [Bomb]
    var isGameOver: Bool = false
    
    init(userNum: Int) {
        self.userNum = userNum
        self.players = []
        self.playersLocation = []
        self.mapItems = []
        self.currentBombs = []
        generateMap()
        generatePlayer(userNum: userNum)
    }
    
    mutating func generateMap() {
        for row in 0..<13 {
            for col in 0..<15 {
                self.mapItems.append(MapItem(row: row, col: col, state: firstMapState[row][col], img: firstMapImage[row][col], originImage: firstMapOriginImage[row][col]))
            }
        }
    }
    
    mutating func generatePlayer(userNum: Int) {
        for i in 1...userNum {
            switch i {
            case 1:
                self.players.append(Player(id: 0))
                self.playersLocation.append(PlayerLocation(id: 0, startRow: 0, startCol: 0))
            case 2:
                self.players.append(Player(id: 1))
                self.playersLocation.append(PlayerLocation(id: 1, startRow: 12, startCol: 14))
            case 3:
                self.players.append(Player(id: 2))
                self.playersLocation.append(PlayerLocation(id: 2, startRow: 0, startCol: 13))
            case 4:
                self.players.append(Player(id: 3))
                self.playersLocation.append(PlayerLocation(id: 3, startRow: 11, startCol: 1))
            default:
                self.players.append(Player(id: 0))
                self.playersLocation.append(PlayerLocation(id: 0, startRow: 0, startCol: 0))
            }
        }
    }
    
}

struct Player: Codable, Identifiable {
    var id: Int
    var bombPower: Int = 1
    var bombNum: Int = 1
    var currentBombsNum: Int = 0
    var isTrapped: Bool = false
    var isLive: Bool = true
    var savingPinNum: Int = 1
    var winning: Bool = false
    
    var dictionary: [String: Any] {
        return ["id": self.id,
                "bombPower": self.bombPower,
                "bombNum": self.bombNum,
                "currentBombsNum": self.currentBombsNum,
                "isTrapped": self.isTrapped,
                "isLive": self.isLive,
                "savingPinNum": self.savingPinNum,
                "winning": self.winning]
    }
    
    init(id: Int) {
        self.id = id
    }
}

struct PlayerLocation: Codable, Identifiable {
    var id: Int
    var currentRow: Int
    var currentCol: Int
    var character: String = "Bazzi-1"
    
    var dictionary: [String: Any] {
        return ["id": self.id,
                "currentRow": self.currentRow,
                "currentCol": self.currentCol,
                "character": self.character]
    }
    
    init(id: Int, startRow: Int, startCol: Int) {
        self.id = id
        self.currentRow = startRow
        self.currentCol = startCol
    }
}

struct MapItem: Codable {
    var row: Int
    var col: Int
    var state: Int
    var img: String
    let originImage: String
    var bombCenterOpacity: Double
    var bombRoadOpacity: Double
    var bombRoadDegree: Double
    var direction: Int
    
    var dictionary: [String: Any] {
        return ["row": self.row,
                "col": self.col,
                "state": self.state,
                "img": self.img,
                "originImage": self.originImage,
                "bombCenterOpacity": self.bombCenterOpacity,
                "bombRoadOpacity": self.bombRoadOpacity,
                "bombRoadDegree": self.bombRoadDegree,
                "direction": self.direction]
    }
    
    init(row: Int, col: Int, state: Int, img: String, originImage: String) {
        self.row = row
        self.col = col
        self.state = state
        self.img = img
        self.originImage = originImage
        self.bombCenterOpacity = 0
        self.bombRoadOpacity = 0
        self.bombRoadDegree = 0
        self.direction = 0
    }
    
    mutating func setDirection(direction: Int) {
        self.direction = direction
    }
}

struct Bomb: Codable, Identifiable {
    var id: Int
    var row: Int
    var col: Int
    var power: Int
    
    var dictionary: [String: Any] {
        return ["id": self.id,
                "row": self.row,
                "col": self.col,
                "power": self.power]
    }
}

struct BombRoad: Codable {
    var row: Int
    var col: Int
    var direction: Int
}
