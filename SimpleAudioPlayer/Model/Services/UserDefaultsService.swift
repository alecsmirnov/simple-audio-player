//
//  UserDefaultsService.swift
//  SimpleAudioPlayer
//
//  Created by admin on 14.05.2021.
//

import Foundation

enum UserDefaultsService {
    private enum Keys: String {
        case volume
    }
    
    private static let defaults = UserDefaults.standard
}

// MARK: - Public Methods

extension UserDefaultsService {
    static func set(volume: Float) {
        defaults.setValue(volume, forKey: Keys.volume.rawValue)
    }
    
    static func getVolume() -> Float? {
        guard let volume = defaults.object(forKey: Keys.volume.rawValue) as? Float else { return nil }
        
        return volume
    }
}
