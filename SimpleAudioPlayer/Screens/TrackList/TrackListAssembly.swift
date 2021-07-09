//
//  TrackListAssembly.swift
//  SimpleAudioPlayer
//
//  Created by admin on 14.05.2021.
//

import UIKit

enum TrackListAssembly {
    static func createTrackListNavigationController() -> UINavigationController {
        let trackListViewController = TrackListViewController()
        let navigationController = UINavigationController(rootViewController: trackListViewController)
        
        trackListViewController.audioPlayer = AudioPlayerService.shared
        
        navigationController.navigationBar.isTranslucent = false
        
        return navigationController
    }
}
