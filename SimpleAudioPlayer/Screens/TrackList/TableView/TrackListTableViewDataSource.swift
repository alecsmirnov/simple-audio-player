//
//  TrackListTableViewDataSource.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import UIKit

final class TrackListTableViewDataSource: NSObject {
    private var audioPlayer: AudioPlayerProtocol {
        return AudioPlayerService.shared
    }
}

// MARK: - UITableViewDataSource

extension TrackListTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioPlayer.tracksCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as? TrackCell
        else {
            return UITableViewCell()
        }
        
        if let track = audioPlayer.track(at: indexPath.row) {
            cell.configure(with: track)
        }
        
        return cell
    }
}
