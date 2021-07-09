//
//  TrackCell.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import UIKit

final class TrackCell: UITableViewCell {
    // MARK: - Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var isPlayed: Bool = false {
        didSet {
            soundIconImageView.image = isPlayed ? AppConstants.Images.soundIconActive : AppConstants.Images.soundIcon
        }
    }
    
    private enum Metrics {
        static let cellSize: CGFloat = 44
        
        static let cellHorizontalSpace: CGFloat = 11
        
        static let soundImageSize: CGFloat = 12
        static let soundImageTrailingSpace: CGFloat = 13
        
        static let nameLabelFontSize: CGFloat = 16
        static let durationLabelFontSize: CGFloat = 14
    }
    
    // MARK: - Subviews
    
    private let soundIconImageView: UIImageView = {
        let soundIconImageView = UIImageView()
        
        soundIconImageView.image = AppConstants.Images.soundIcon
        
        return soundIconImageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        
        nameLabel.textColor = AppConstants.Colors.trackTitle
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: Metrics.nameLabelFontSize)
        nameLabel.sizeToFit()
        
        return nameLabel
    }()
    
    private let durationLabel: UILabel = {
        let durationLabel = UILabel()
        
        durationLabel.textColor = AppConstants.Colors.trackTitle
        durationLabel.font = UIFont(name: "HelveticaNeue-Light", size: Metrics.durationLabelFontSize)
        durationLabel.textAlignment = .right
        
        return durationLabel
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isPlayed = false
    }
}

// MARK: - Public Methods

extension TrackCell {
    func configure(with track: Track) {
        nameLabel.text = track.name
        durationLabel.text = track.duration.formattedStringTime
        isPlayed = track.isPlayed
    }
}

// MARK: - Appearance

private extension TrackCell {
    func setupAppearance() {
        backgroundColor = .clear
        
        setupSelectedBackgroundColor()
    }
    
    func setupSelectedBackgroundColor() {
        let colorView = UIView()
        
        colorView.backgroundColor = AppConstants.Colors.cellSelectionBackground
        selectedBackgroundView = colorView
    }
}

// MARK: - Layout

private extension TrackCell {
    func setupLayout() {
        contentView.addSubview(soundIconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(durationLabel)
        
        setupSoundIconImageViewLayout()
        setupNameLabelLayout()
        setupDurationLabelLayout()
    }
    
    func setupSoundIconImageViewLayout() {
        soundIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            soundIconImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            soundIconImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Metrics.cellHorizontalSpace),
            soundIconImageView.heightAnchor.constraint(equalToConstant: Metrics.soundImageSize),
            soundIconImageView.widthAnchor.constraint(equalToConstant: Metrics.soundImageSize)
        ])
    }
    
    func setupNameLabelLayout() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: soundIconImageView.trailingAnchor,
                constant: Metrics.soundImageTrailingSpace),
            nameLabel.heightAnchor.constraint(equalToConstant: Metrics.cellSize)
        ])
        
        let bottomConstraint = nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        bottomConstraint.priority = .defaultLow
        bottomConstraint.isActive = true
    }
    
    func setupDurationLabelLayout() {
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            durationLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            durationLabel.leadingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor,
                constant: Metrics.soundImageTrailingSpace),
            durationLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Metrics.cellHorizontalSpace)
        ])
    }
}
