//
//  TrackListViewController.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import UIKit

final class TrackListViewController: UIViewController {
    // MARK: - Properties
    
    private var trackListView: TrackListView? {
        guard let trackListView = view as? TrackListView else { return nil }
        
        return trackListView
    }
    
    weak var audioPlayer: AudioPlayerProtocol?
    
    private var previousTrackIndex: Int?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TrackListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateAudioPlayer()
    }
}

// MARK: - Appearance

private extension TrackListViewController {
    func setupAppearance() {
        setupNavigationControllerAppearance()
    }
    
    func setupNavigationControllerAppearance() {
        navigationItem.title = "Playlist"
        
        let font: Any = UIFont(name: "HelveticaNeue-Thin", size: 21) as Any
        let attributedText: [NSAttributedString.Key: Any] = [.font: font]
        
        navigationController?.navigationBar.titleTextAttributes = attributedText
    }
}

// MARK: - Private Methods

private extension TrackListViewController {
    func updateAudioPlayer() {
        AudioPlayerService.shared.delegate = self
        
        if let previousTrackIndex = previousTrackIndex {
            trackListView?.setInactiveTrack(at: previousTrackIndex)
        }
        
        if let currentTrackIndex = audioPlayer?.currentTrackIndex {
            trackListView?.setActiveTrack(at: currentTrackIndex)
        }
    }
}

// MARK: - Actions

private extension TrackListViewController {
    func setupActions() {
        trackListView?.didSelectRowAtIndexCompletion = { [weak self] index in
            if let previousTrackIndex = self?.audioPlayer?.currentTrackIndex {
                self?.trackListView?.setInactiveTrack(at: previousTrackIndex)
            }
            
            let trackDetailViewController = TrackDetailAssembly.createTrackDetailViewController(with: index)
            
            self?.navigationController?.pushViewController(trackDetailViewController, animated: true)
        }
    }
}

// MARK: - AudioPlayerDelegateState

extension TrackListViewController: AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayerProtocol, didChangeState state: AudioPlayerState) {
        if state == .finished {
            previousTrackIndex = nil
        }
    }
    
    func audioPlayerDidStartPlayingTrack(_ audioPlayer: AudioPlayerProtocol, with index: Int) {
        previousTrackIndex = audioPlayer.currentTrackIndex
        
        trackListView?.setActiveTrack(at: index)
    }
    
    func audioPlayerDidFinishPlayingTrack(_ audioPlayer: AudioPlayerProtocol, with index: Int) {
        previousTrackIndex = index
        
        trackListView?.setInactiveTrack(at: index)
    }
}
