//
//  SceneDelegate.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let audioPlayer: AudioPlayerProtocol = AudioPlayerService.shared
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = TrackListAssembly.createTrackListNavigationController()
        window?.makeKeyAndVisible()
        
        setupAudioPlayerMusic()
    }
}

// MARK: - AudioPlayer

private extension SceneDelegate {
    func setupAudioPlayerMusic() {
        guard let resourcePath = Bundle.main.resourcePath else { return }

        let fileManager = FileManager.default
        let suffix = ".mp3"
        
        do {
            let items = try fileManager.contentsOfDirectory(atPath: resourcePath)
            
            for item in items where item.hasSuffix(suffix) {
                audioPlayer.append(String(item.dropLast(suffix.count)))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
