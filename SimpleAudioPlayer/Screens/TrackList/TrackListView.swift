//
//  TrackListView.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import UIKit

final class TrackListView: UIView {
    // MARK: - Properties
    
    var didSelectRowAtIndexCompletion: ((Int) -> Void)?
    
    private let trackListTableViewDataSource = TrackListTableViewDataSource()
    
    // swiftlint:disable weak_delegate
    
    private let trackListTableViewDelegate = TrackListTableViewDelegate()
    
    // swiftlint:enable weak_delegate
    
    // MARK: - Subviews
    
    private let trackListTableView: UITableView = {
        let trackListTableView = UITableView()
        
        trackListTableView.rowHeight = UITableView.automaticDimension
        trackListTableView.estimatedRowHeight = 44
        trackListTableView.separatorInset = .zero
        
        return trackListTableView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension TrackListView {
    func setActiveTrack(at index: Int) {
        guard let trackCell = trackCell(at: index) else { return }
        
        trackCell.isPlayed = true
        
    }
    
    func setInactiveTrack(at index: Int) {
        guard let trackCell = trackCell(at: index) else { return }
        
        trackCell.isPlayed = false
    }
    
    private func trackCell(at index: Int) -> TrackCell? {
        let indexPath = IndexPath(row: index, section: 0)
        let cell = trackListTableView.cellForRow(at: indexPath) as? TrackCell
        
        return cell
    }
}

// MARK: - Appearance

private extension TrackListView {
    func setupAppearance() {
        backgroundColor = AppConstants.Colors.background
        
        setupTrackListTableViewAppearance()
    }
    
    func setupTrackListTableViewAppearance() {
        trackListTableView.backgroundColor = .clear
        trackListTableView.separatorColor = AppConstants.Colors.trackListTableViewSeparator
        
        trackListTableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        
        trackListTableView.dataSource = trackListTableViewDataSource
        trackListTableView.delegate = trackListTableViewDelegate
        
        trackListTableViewDelegate.didSelectRowAtIndexCompletion = { [weak self] index in
            self?.didSelectRowAtIndexCompletion?(index)
            
            let indexPath = IndexPath(row: index, section: 0)
            
            self?.trackListTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - Layout

private extension TrackListView {
    func setupLayout() {
        addSubview(trackListTableView)
        
        setupTrackListTableViewLayout()
    }
    
    func setupTrackListTableViewLayout() {
        trackListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trackListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            trackListTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            trackListTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            trackListTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
