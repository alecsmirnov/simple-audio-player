//
//  AudioPlayerService.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import AVFoundation
import Foundation

final class AudioPlayerService: NSObject {
    // MARK: - Properties
    
    static let shared = AudioPlayerService()
    
    weak var delegate: AudioPlayerDelegate?
    
    var tracksCount: Int {
        return tracks.count
    }
    
    var currentTrackTime: Float {
        return Float(player?.currentTime ?? 0)
    }
    
    private(set) var currentTrackIndex: Int?
    private(set) var currentTrackName: String?
    private(set) var currentTrackDuration: Float?
    
    private(set) var state: AudioPlayerState = .prepared {
        didSet {
            delegate?.audioPlayer(self, didChangeState: state)
        }
    }
    
    var volume: Float {
        didSet {
            player?.volume = volume
            
            UserDefaultsService.set(volume: self.volume)
        }
    }
    
    private var tracks: [Track] = []
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    // MARK: - Lifecycle
    
    private override init() {
        volume = UserDefaultsService.getVolume() ?? 0.5
    }
}

// MARK: - AudioPlayerProtocol

extension AudioPlayerService: AudioPlayerProtocol {
    func append(_ filename: String) {
        guard let pathString = Bundle.main.path(forResource: filename, ofType: "mp3") else { return }
        
        let url = URL(fileURLWithPath: pathString)
        let asset = AVAsset(url: url)
        let duration = Float(asset.duration.seconds)
        let item = AVPlayerItem(url: url)
        
        var artist: String?
        var title: String?
        var artworkData: Data?
        
        for metadataItem in item.asset.commonMetadata {
            if metadataItem.commonKey == .commonKeyArtist {
                artist = metadataItem.stringValue
            }
            
            if metadataItem.commonKey == .commonKeyTitle {
                title = metadataItem.stringValue
            }
            
            if metadataItem.commonKey == .commonKeyArtwork {
                artworkData = metadataItem.dataValue
            }
        }
        
        let track = Track(
            filename: filename,
            url: url,
            duration: duration,
            artworkData: artworkData,
            artist: artist,
            title: title)
        
        tracks.append(track)
    }
    
    func track(at index: Int) -> Track? {
        guard tracks.indices.contains(index) else { return nil }
        
        return tracks[index]
    }
    
    @discardableResult
    func start(with index: Int) -> Bool {
        guard tracks.indices.contains(index) else { return false }
        
        let prepared = prepareTrack(at: index) { [self] in
            playTrack()
            
            if let currentTrackIndex = currentTrackIndex {
                tracks[currentTrackIndex].isPlayed = false
            }
            
            currentTrackIndex = index
            currentTrackName = tracks[index].name
            currentTrackDuration = Float(player?.duration ?? 0)
            
            tracks[index].isPlayed = true
            
            delegate?.audioPlayerDidStartPlayingTrack(self, with: index)
        }
        
        return prepared
    }
    
    @discardableResult
    func nextTrack() -> Bool {
        guard
            let nextTrackIndex = nextTrackIndex(),
            let currentTrackIndex = currentTrackIndex
        else {
            return false
        }
        
        tracks[currentTrackIndex].isPlayed = false
        
        delegate?.audioPlayerDidFinishPlayingTrack(self, with: currentTrackIndex)
        
        timer?.invalidate()
        
        return start(with: nextTrackIndex)
    }
    
    @discardableResult
    func previousTrack() -> Bool {
        guard
            let previousTrackIndex = previousTrackIndex(),
            let currentTrackIndex = currentTrackIndex
        else {
            return false
        }
        
        tracks[currentTrackIndex].isPlayed = false
        
        delegate?.audioPlayerDidFinishPlayingTrack(self, with: currentTrackIndex)
        
        timer?.invalidate()
        
        return start(with: previousTrackIndex)
    }
    
    func stop() {
        state = .stopped
        
        player?.pause()
        
        timer?.invalidate()
    }
    
    func continueTrack() {
        if state == .stopped {
            playTrack()
        }
    }
    
    func setCurrentTrackPosition(time: Float) {        
        player?.currentTime = TimeInterval(time)
    }
}

// MARK: - Private Methods

private extension AudioPlayerService {
    func nextTrackIndex() -> Int? {
        guard let currentTrackIndex = currentTrackIndex else { return nil }
        
        let nextTrackIndex = currentTrackIndex + 1
        
        guard tracks.indices.contains(nextTrackIndex) else { return nil }
        
        return nextTrackIndex
    }
    
    func previousTrackIndex() -> Int? {
        guard let currentTrackIndex = currentTrackIndex else { return nil }
        
        let previousTrackIndex = currentTrackIndex - 1
        
        guard tracks.indices.contains(previousTrackIndex) else { return nil }
        
        return previousTrackIndex
    }
    
    func prepareTrack(at index: Int, completion: @escaping () -> Void) -> Bool {
        let trackURL = tracks[index].url
        
        DispatchQueue.global(qos: .background).async {
            do {
                try self.player = AVAudioPlayer(contentsOf: trackURL)
                
                self.player?.delegate = self
            } catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }

        return true
    }
    
    func playTrack() {
        state = .started
        
        player?.volume = volume
        player?.play()
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.001,
            target: self,
            selector: #selector(didChangeCurrentTime),
            userInfo: nil,
            repeats: true)
    }
    
    func clearCurrentTrackInfo() {
        currentTrackIndex = nil
        currentTrackName = nil
        currentTrackDuration = nil
    }
}

// MARK: - Actions

private extension AudioPlayerService {
    @objc
    func didChangeCurrentTime() {
        let time = Float(player?.currentTime ?? 0)
        
        delegate?.audioPlayerDidChangeCurrentTime(self, time: time)
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayerService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        
        if let currentTrackIndex = currentTrackIndex {
            tracks[currentTrackIndex].isPlayed = false
            
            delegate?.audioPlayerDidFinishPlayingTrack(self, with: currentTrackIndex)
        }
        
        if let nextTrackIndex = nextTrackIndex() {            
            start(with: nextTrackIndex)
        } else {
            state = .finished
            
            clearCurrentTrackInfo()
            
            delegate?.audioPlayerDidFinishPlayer(self)
        }
    }
}
