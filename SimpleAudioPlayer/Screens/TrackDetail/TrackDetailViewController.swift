//
//  TrackDetailViewController.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import UIKit

final class TrackDetailViewController: UIViewController {
    // MARK: - Properties
    
    weak var audioPlayer: AudioPlayerProtocol?
    
    var trackIndex: Int?
    
    private var trackDetailView: TrackDetailView? {
        guard let trackDetailView = view as? TrackDetailView else { return nil }
        
        return trackDetailView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TrackDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupTrack()
    }
}

// MARK: - Appearance

private extension TrackDetailViewController {
    func setupAppearance() {
        trackDetailView?.delegate = self
        audioPlayer?.delegate = self
        
        if let volume = audioPlayer?.volume {
            trackDetailView?.volume = volume
        }
        
        setupNavigationControllerAppearance()
        customizeBackButton()
    }
    
    func setupNavigationControllerAppearance() {
        let logoImageView = UIImageView(image: AppConstants.Images.logoIcon)
        
        navigationItem.titleView = logoImageView
    }
    
    func customizeBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        
        let image = AppConstants.Images.backButton?.withRenderingMode(.alwaysOriginal)
        
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
    }
}

// MARK: - Private Methods

private extension TrackDetailViewController {
    func setupTrack() {
        guard let trackIndex = trackIndex else { return }
        
        trackDetailView?.setCurrentTime(0)
        trackDetailView?.playButtonState = .stop
        
        if let track = audioPlayer?.track(at: trackIndex) {
            trackDetailView?.setTrack(name: track.name)
            trackDetailView?.setDurationTime(track.duration)
            
            if let artworkData = track.artworkData {
                trackDetailView?.setArtworkData(artworkData)
            }
        }
        
        if let currentTrackIndex = audioPlayer?.currentTrackIndex, currentTrackIndex == trackIndex {
            guard
                let currentTrackTime = audioPlayer?.currentTrackTime,
                let sliderValue = timeToSliderValue(currentTrackTime)
            else {
                return
            }
            
            trackDetailView?.setCurrentTime(currentTrackTime)
            trackDetailView?.setSliderValue(sliderValue)
            
            audioPlayer?.continueTrack()
        } else {
            audioPlayer?.start(with: trackIndex)
        }
    }
    
    func timeToSliderValue(_ time: Float) -> Float? {
        guard let maximumValue = audioPlayer?.currentTrackDuration else { return nil }
        
        let sliderValue = time / maximumValue
        
        return sliderValue
    }
    
    func sliderValueToTime(value: Float) -> Float? {
        guard let duration = audioPlayer?.currentTrackDuration else { return nil }

        let time = value * duration
        
        return time
    }
}

// MARK: - TrackDetailViewDelegate

extension TrackDetailViewController: TrackDetailViewDelegate {
    func trackDetailViewDidTapStartButton(_ trackDetailView: TrackDetailView) {
        guard
            let trackIndex = audioPlayer?.currentTrackIndex,
            let audioPlayerState = audioPlayer?.state
        else {
            return
        }
        
        switch audioPlayerState {
        case .prepared:
            audioPlayer?.start(with: trackIndex)
        case .stopped:
            audioPlayer?.continueTrack()
        default:
            break
        }
    }
    
    func trackDetailViewDidTapStopButton(_ trackDetailView: TrackDetailView) {
        audioPlayer?.stop()
    }
    
    func trackDetailViewDidTapPreviousTrackButton(_ trackDetailView: TrackDetailView) {
        audioPlayer?.previousTrack()
    }
    
    func trackDetailViewDidTapNextTrackButton(_ trackDetailView: TrackDetailView) {
        audioPlayer?.nextTrack()
    }
    
    func trackDetailViewDidChangeSlider(_ trackDetailView: TrackDetailView, value: Float) {
        guard let time = sliderValueToTime(value: value) else { return }
        
        audioPlayer?.setCurrentTrackPosition(time: time)
    }
    
    func trackDetailViewDidChangeVolumeSlider(_ trackDetailView: TrackDetailView, value: Float) {
        audioPlayer?.volume = value
    }
    
    func trackDetailViewDidTapVolumeMinButton(_ trackDetailView: TrackDetailView) {
        audioPlayer?.volume = 0
    }
    
    func trackDetailViewDidTapVolumeMaxButton(_ trackDetailView: TrackDetailView) {
        audioPlayer?.volume = 1
    }
}

// MARK: - AudioplayerServiceDelegate

extension TrackDetailViewController: AudioPlayerDelegate {
    func audioPlayerDidChangeCurrentTime(_ audioPlayer: AudioPlayerProtocol, time: Float) {
        guard let sliderValue = timeToSliderValue(time) else { return }

        trackDetailView?.setCurrentTime(time)
        trackDetailView?.setSliderValue(sliderValue)
    }
    
    func audioPlayerDidStartPlayingTrack(_ audioPlayer: AudioPlayerProtocol, with index: Int) {
        guard
            let currentTrackIndex = audioPlayer.currentTrackIndex,
            let currentTrack = audioPlayer.track(at: currentTrackIndex)
        else {
            return
        }
        
        trackDetailView?.setCurrentTime(0)
        trackDetailView?.setSliderValue(0, animated: false)
        trackDetailView?.setDurationTime(currentTrack.duration)
        trackDetailView?.setTrack(name: currentTrack.name)
        trackDetailView?.setArtworkData(currentTrack.artworkData)
    }
    
    func audioPlayerDidStopPlayer(_ audioPlayer: AudioPlayerProtocol) {
        trackDetailView?.playButtonState = .start
    }
    
    func audioPlayerDidFinishPlayer(_ audioPlayer: AudioPlayerProtocol) {
        trackDetailView?.playButtonState = .stop
    }
}
