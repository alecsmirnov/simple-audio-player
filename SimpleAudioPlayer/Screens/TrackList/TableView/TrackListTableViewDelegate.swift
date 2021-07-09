//
//  TrackListTableViewDelegate.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import UIKit

final class TrackListTableViewDelegate: NSObject {
    var didSelectRowAtIndexCompletion: ((Int) -> Void)?
}

// MARK: - UITableViewDelegate

extension TrackListTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexCompletion?(indexPath.row)
    }
}
