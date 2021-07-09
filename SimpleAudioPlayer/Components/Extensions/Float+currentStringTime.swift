//
//  Float+formattedStringTime.swift
//  SimpleAudioPlayer
//
//  Created by admin on 12.05.2021.
//

import Foundation

extension Float {
    var formattedStringTime: String {
        let minutes = Int(self / 60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        
        let formattedStringTime = String(format: "%02d:%02d", minutes, seconds)
        
        return formattedStringTime
    }
}
