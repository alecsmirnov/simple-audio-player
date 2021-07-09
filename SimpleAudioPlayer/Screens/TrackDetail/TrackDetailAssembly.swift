//
//  TrackDetailAssembly.swift
//  SimpleAudioPlayer
//
//  Created by admin on 14.05.2021.
//

import UIKit

enum TrackDetailAssembly {
    static func createTrackDetailViewController(with index: Int) -> TrackDetailViewController {
        let trackDetailViewController = TrackDetailViewController()
        
        trackDetailViewController.trackIndex = index
        trackDetailViewController.audioPlayer = AudioPlayerService.shared
        
        return trackDetailViewController
    }
}
