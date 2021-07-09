//
//  AudioPlayerProtocol.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayer(_ audioPlayer: AudioPlayerProtocol, didChangeState state: AudioPlayerState)
    func audioPlayerDidChangeCurrentTime(_ audioPlayer: AudioPlayerProtocol, time: Float)
    func audioPlayerDidStopPlayer(_ audioPlayer: AudioPlayerProtocol)
    func audioPlayerDidStartPlayingTrack(_ audioPlayer: AudioPlayerProtocol, with index: Int)
    func audioPlayerDidFinishPlayingTrack(_ audioPlayer: AudioPlayerProtocol, with index: Int)
    func audioPlayerDidFinishPlayer(_ audioPlayer: AudioPlayerProtocol)
}

extension AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayerProtocol, didChangeState state: AudioPlayerState) {}
    func audioPlayerDidChangeCurrentTime(_ audioPlayer: AudioPlayerProtocol, time: Float) {}
    func audioPlayerDidStopPlayer(_ audioPlayer: AudioPlayerProtocol) {}
    func audioPlayerDidStartPlayingTrack(_ audioPlayer: AudioPlayerProtocol, with index: Int) {}
    func audioPlayerDidFinishPlayingTrack(_ audioPlayer: AudioPlayerProtocol, with index: Int) {}
    func audioPlayerDidFinishPlayer(_ audioPlayer: AudioPlayerProtocol) {}
}

protocol AudioPlayerProtocol: AnyObject {
    var delegate: AudioPlayerDelegate? { get set }
    
    var tracksCount: Int { get }
    var currentTrackTime: Float { get }
    var currentTrackIndex: Int? { get }
    var currentTrackName: String? { get }
    var currentTrackDuration: Float? { get }
    var state: AudioPlayerState { get }
    
    var volume: Float { get set }
    
    func append(_ track: String)
    func track(at index: Int) -> Track?
    
    @discardableResult
    func start(with index: Int) -> Bool
    
    @discardableResult
    func nextTrack() -> Bool
    
    @discardableResult
    func previousTrack() -> Bool
    
    func stop()
    func continueTrack()
    func setCurrentTrackPosition(time: Float)
}

extension AudioPlayerProtocol {
    func start() {
        start(with: 0)
    }
}
