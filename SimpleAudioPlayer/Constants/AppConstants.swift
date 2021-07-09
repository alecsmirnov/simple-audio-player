//
//  AppConstants.swift
//  SimpleAudioPlayer
//
//  Created by admin on 12.05.2021.
//

import UIKit

enum AppConstants {
    enum Colors {
        static let background: UIColor = #colorLiteral(red: 0.1294117, green: 0.1372549, blue: 0.1607843, alpha: 1)
        static let headerBackground: UIColor = #colorLiteral(red: 0.2366987765, green: 0.2520599961, blue: 0.2835647464, alpha: 1)
        
        static let trackTitle: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        static let cellSelectionBackground: UIColor = .systemBlue
        static let tintColor = cellSelectionBackground
        
        static let trackListTableViewSeparator: UIColor = #colorLiteral(red: 0.3618559539, green: 0.37580055, blue: 0.4120317996, alpha: 1)
    }
    
    enum Images {
        static let logoIcon: UIImage? = nil
        
        static let backButton = UIImage(systemName: "chevron.backward")
        
        static let soundIcon = UIImage(systemName: "music.note")
        static let soundIconActive = UIImage(systemName: "circle.fill")
        
        static let playButton = UIImage(systemName: "play.circle.fill")
        static let pauseButton = UIImage(systemName: "pause.circle.fill")
        static let previousButton = UIImage(systemName: "arrowtriangle.backward.circle")
        static let nextButton = UIImage(systemName: "arrowtriangle.forward.circle")
        
        static let volumeMin = UIImage(systemName: "speaker.fill")
        static let volumeMax = UIImage(systemName: "speaker.wave.3.fill")
        
        static let defaultArtwork: UIImage? = nil
    }
}
