//
//  Track.swift
//  SimpleAudioPlayer
//
//  Created by admin on 12.05.2021.
//

import Foundation

struct Track {
    let filename: String
    let url: URL
    let duration: Float
    
    var artworkData: Data?
    var artist: String?
    var title: String?
    
    var isPlayed: Bool = false
}

extension Track {
    var name: String {
        let name: String
        
        if artist == nil && title == nil {
            name = filename
        } else {
            name = "\(artist ?? "Unknown") - \(title ?? "Unknown")"
        }
        
        return name
    }
}
