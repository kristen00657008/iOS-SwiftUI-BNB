//
//  extension.swift
//  Final Project
//
//  Created by Chase on 2021/4/26.
//

import Foundation
import SwiftUI
import AVFoundation

extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension AnyTransition {
    static var bottomTransition: AnyTransition {
        let insertion = AnyTransition.offset(x: 0, y: UIScreen.main.bounds.height / 2)
        let removal = AnyTransition.offset(x: 0, y: UIScreen.main.bounds.height / -2)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension AVPlayer {
    
    static var queuePlayer = AVQueuePlayer()

    static var playerLooper: AVPlayerLooper!
    
    static func playLoginMusic() {
        queuePlayer.removeAllItems()
        guard let Url = Bundle.main.url(forResource: "login_music", withExtension: "mp3") else{fatalError("Failed to fin sound file.")}
        let item = AVPlayerItem(url: Url)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.play()
    }
    
    static func playLobbyMusic() {
        queuePlayer.removeAllItems()
        guard let Url = Bundle.main.url(forResource: "lobby_music", withExtension: "mp3") else{fatalError("Failed to fin sound file.")}
        let item = AVPlayerItem(url: Url)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.play()
    }
    
    
    static func playWaitMusic() {
        queuePlayer.removeAllItems()
        guard let Url = Bundle.main.url(forResource: "wait_music", withExtension: "mp3") else{fatalError("Failed to fin sound file.")}
        let item = AVPlayerItem(url: Url)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.play()
    }
    
    static func playGameMusic() {
        queuePlayer.removeAllItems()
        guard let Url = Bundle.main.url(forResource: "game_music", withExtension: "mp3") else{fatalError("Failed to fin sound file.")}
        let item = AVPlayerItem(url: Url)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.play()
    }
    
    static let gameStartPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "game_start", withExtension: "mov") else{fatalError("Failed to fin sound file.")}
        return AVPlayer(url: url)
    }()
    
    static let winPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "win", withExtension: "mov") else{fatalError("Failed to fin sound file.")}
        return AVPlayer(url: url)
    }()
    
    static let losePlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "lose", withExtension: "mov") else{fatalError("Failed to fin sound file.")}
        return AVPlayer(url: url)
    }()
    
    static let trapPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "trap", withExtension: "mov") else{fatalError("Failed to fin sound file.")}
        return AVPlayer(url: url)
    }()
    
    static let bombedPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "bombed", withExtension: "mov") else{fatalError("Failed to fin sound file.")}
        return AVPlayer(url: url)
    }()
    
    func playFromStart() {
        seek(to: .zero)
        play()
    }
    
}


final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
