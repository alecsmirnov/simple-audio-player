//
//  TrackDetailView.swift
//  SimpleAudioPlayer
//
//  Created by admin on 11.05.2021.
//

import UIKit

protocol TrackDetailViewDelegate: AnyObject {
    func trackDetailViewDidTapStartButton(_ trackDetailView: TrackDetailView)
    func trackDetailViewDidTapStopButton(_ trackDetailView: TrackDetailView)
    
    func trackDetailViewDidTapPreviousTrackButton(_ trackDetailView: TrackDetailView)
    func trackDetailViewDidTapNextTrackButton(_ trackDetailView: TrackDetailView)
    
    func trackDetailViewDidTapVolumeMinButton(_ trackDetailView: TrackDetailView)
    func trackDetailViewDidTapVolumeMaxButton(_ trackDetailView: TrackDetailView)
    
    func trackDetailViewDidChangeSlider(_ trackDetailView: TrackDetailView, value: Float)
    func trackDetailViewDidChangeVolumeSlider(_ trackDetailView: TrackDetailView, value: Float)
}

final class TrackDetailView: UIView {
    // MARK: - Properties
    
    weak var delegate: TrackDetailViewDelegate?
    
    enum PlayButtonState: String {
        case start = "Start"
        case stop = "Stop"
    }

    var playButtonState: PlayButtonState = .start {
        didSet {
            setupPlayButtonAppearance()
        }
    }
    
    var volume: Float {
        get {
            return volumeSlider.value
        }
        set {
            volumeSlider.value = newValue
        }
    }
    
    private enum Metrics {
        static let artworkImageViewTopSpace: CGFloat = 8
        static let artworkImageViewBottomSpace: CGFloat = 9
        static let artworkImageViewHorizontalSpace: CGFloat = 17
        
        static let sliderHorizontalSpace: CGFloat = 6
        static let sliderHeight: CGFloat = 11
        
        static let playButtonSize: CGFloat = 80
        static let playButtonHorizontalSpace: CGFloat = 35
        
        static let previousNextButtonSize: CGFloat = 55
        
        static let infoViewBottomSpace: CGFloat = 10
        
        static let volumeViewHeight: CGFloat = 18
        static let volumeViewTopSpace: CGFloat = 10
        static let volumeViewBottomSpace: CGFloat = 19
        static let volumeViewHorizontalSpace: CGFloat = 12
        
        static let volumeMinMaxHeight: CGFloat = 18
        static let volumeMinMaxWidth: CGFloat = 21
        
        static let volumeSliderHorizontalSpace: CGFloat = 16
        
        static let nameLabelFontSize: CGFloat = 16
        static let timersHeight: CGFloat = 15
        static let timersWidth: CGFloat = 31
        static let timersFontSize: CGFloat = 12
    }
    
    // MARK: - Subviews
    
    // MARK: HeaderView
    
    private let headerView = UIView()
    private let artworkView = UIView()
    
    private let artworkImageView: UIImageView = {
        let artworkImageView = UIImageView()
        
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.clipsToBounds = true
        
        return artworkImageView
    }()
    
    // MARK: InfoView
    
    private let infoView: UIView = {
        let infoView = UIView()
        
        infoView.backgroundColor = AppConstants.Colors.headerBackground
        
        return infoView
    }()
    
    private let soundIconNameView = UIView()
    
    private let soundIconImageView: UIImageView = {
        let soundIconImageView = UIImageView()
        
        soundIconImageView.image = AppConstants.Images.soundIcon
        
        return soundIconImageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: Metrics.nameLabelFontSize)
        nameLabel.textColor = AppConstants.Colors.trackTitle
        
        return nameLabel
    }()
    
    private let currentTimeLabel: UILabel = {
        let currentTimeLabel = UILabel()
        
        currentTimeLabel.textAlignment = .center
        currentTimeLabel.font = UIFont(name: "HelveticaNeue-Thin", size: Metrics.timersFontSize)
        
        return currentTimeLabel
    }()
    
    private let slider: CustomSlider = {
        let slider = CustomSlider()
        
        slider.trackTintColor = .white
        slider.trackHighlightTintColor = AppConstants.Colors.tintColor
        slider.minimumValue = 0
        slider.maximumValue = 1
        
        slider.layer.masksToBounds = true
        slider.layer.cornerRadius = 14
        
        return slider
    }()
    
    private let durationLabel: UILabel = {
        let durationLabel = UILabel()
        
        durationLabel.textAlignment = .center
        durationLabel.font = UIFont(name: "HelveticaNeue-Thin", size: Metrics.timersFontSize)
        
        return durationLabel
    }()
    
    // MARK: VolumeView
    
    private let volumeView = UIView()
    
    private let volumeMinButton: UIButton = {
        let volumeMinButton = UIButton(type: .system)
        
        volumeMinButton.setImage(AppConstants.Images.volumeMin?.withRenderingMode(.alwaysOriginal), for: .normal)
        volumeMinButton.imageView?.contentMode = .scaleAspectFit
        volumeMinButton.contentVerticalAlignment = .fill
        volumeMinButton.contentHorizontalAlignment = .fill
        
        return volumeMinButton
    }()
    
    private let volumeSlider: UISlider = {
        let volumeSlider = UISlider()
        
        volumeSlider.tintColor = AppConstants.Colors.tintColor
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 1
        
        return volumeSlider
    }()
    
    private let volumeMaxButton: UIButton = {
        let volumeMaxButton = UIButton(type: .system)
        
        volumeMaxButton.setImage(AppConstants.Images.volumeMax?.withRenderingMode(.alwaysOriginal), for: .normal)
        volumeMaxButton.imageView?.contentMode = .scaleAspectFit
        volumeMaxButton.contentVerticalAlignment = .fill
        volumeMaxButton.contentHorizontalAlignment = .fill
        
        return volumeMaxButton
    }()
    
    // MARK: ControllerView
    
    private let controllerView = UIView()
    private let buttonsView = UIView()
    
    private let playButton: UIButton = {
        let playButton = UIButton(type: .system)
        
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.contentVerticalAlignment = .fill
        playButton.contentHorizontalAlignment = .fill
        
        return playButton
    }()
    
    private let previousTrackButton: UIButton = {
        let previousTrackButton = UIButton(type: .system)
        let image = AppConstants.Images.previousButton?.withRenderingMode(.alwaysOriginal)
        
        previousTrackButton.setImage(image, for: .normal)
        previousTrackButton.imageView?.contentMode = .scaleAspectFit
        previousTrackButton.contentVerticalAlignment = .fill
        previousTrackButton.contentHorizontalAlignment = .fill
        
        return previousTrackButton
    }()
    
    private let nextTrackButton: UIButton = {
        let nextTrackButton = UIButton(type: .system)
        let image = AppConstants.Images.nextButton?.withRenderingMode(.alwaysOriginal)
        
        nextTrackButton.setImage(image, for: .normal)
        nextTrackButton.imageView?.contentMode = .scaleAspectFit
        nextTrackButton.contentVerticalAlignment = .fill
        nextTrackButton.contentHorizontalAlignment = .fill
        
        return nextTrackButton
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension TrackDetailView {
    func setSliderValue(_ value: Float, animated: Bool = true) {
        slider.value = CGFloat(value)
    }
    
    func setTrack(name: String?) {
        nameLabel.text = name
    }
    
    func setCurrentTime(_ time: Float) {
        currentTimeLabel.text = time.formattedStringTime
    }
    
    func setDurationTime(_ time: Float) {
        durationLabel.text = time.formattedStringTime
    }
    
    func setArtworkData(_ data: Data?) {
        guard let data = data else {
            artworkImageView.image = AppConstants.Images.defaultArtwork
            
            return
        }
        
        artworkImageView.image = UIImage(data: data)
    }
}

// MARK: - Appearance

private extension TrackDetailView {
    func setupAppearance() {
        backgroundColor = AppConstants.Colors.background
        headerView.backgroundColor = AppConstants.Colors.headerBackground
        
        setupPlayButtonAppearance()
        
        slider.delegate = self
    }
    
    func setupPlayButtonAppearance() {
        let image: UIImage?
        
        switch playButtonState {
        case .start:
            image = AppConstants.Images.playButton
        case .stop:
            image = AppConstants.Images.pauseButton
        }
        
        playButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}

// MARK: - Layout

private extension TrackDetailView {
    func setupLayout() {
        addSubview(headerView)
        addSubview(infoView)
        addSubview(controllerView)
        
        headerView.addSubview(artworkView)
        
        artworkView.addSubview(artworkImageView)

        infoView.addSubview(slider)
        infoView.addSubview(currentTimeLabel)
        infoView.addSubview(durationLabel)
        infoView.addSubview(soundIconNameView)

        soundIconNameView.addSubview(soundIconImageView)
        soundIconNameView.addSubview(nameLabel)

        controllerView.addSubview(volumeView)
        controllerView.addSubview(buttonsView)

        volumeView.addSubview(volumeMinButton)
        volumeView.addSubview(volumeSlider)
        volumeView.addSubview(volumeMaxButton)

        buttonsView.addSubview(previousTrackButton)
        buttonsView.addSubview(playButton)
        buttonsView.addSubview(nextTrackButton)
        
        setupHeaderViewLayout()
        setupInfoViewLayout()
        setupControllerViewLayout()
        
        setupArtworkViewLayout()
        setupArtworkImageViewLayout()
        
        setupSliderLayout()
        setupCurrentTimeLabelLayout()
        setupDurationLabelLayout()

        setupSoundIconNameView()
        setupSoundIconImageViewLayout()
        setupTrackNameLabelLayout()

        setupVolumeViewLayout()
        setupVolumeMinButtonLayout()
        setupVolumeSliderLayout()
        setupVolumeMaxButtonLayout()

        setupButtonsViewLayout()
        setupPlayButtonLayout()
        setupPreviousTrackButtonLayout()
        setupNextTrackButtonLayout()
    }
    
    // MARK: HeaderView
    
    func setupHeaderViewLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            headerView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
        ])
        
        let heightConstraint = headerView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
        
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
    }
    
    func setupArtworkViewLayout() {
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(
                equalTo: headerView.topAnchor,
                constant: Metrics.artworkImageViewTopSpace),
            artworkView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            artworkView.widthAnchor.constraint(
                equalTo: safeAreaLayoutGuide.widthAnchor,
                constant: -2 * Metrics.artworkImageViewHorizontalSpace),
            artworkView.bottomAnchor.constraint(
                equalTo: infoView.topAnchor,
                constant: -Metrics.artworkImageViewTopSpace)
        ])
    }
    
    func setupArtworkImageViewLayout() {
        artworkImageView.translatesAutoresizingMaskIntoConstraints = false
        artworkImageView.setContentHuggingPriority(UILayoutPriority(500), for: .vertical)
        artworkImageView.setContentHuggingPriority(UILayoutPriority(500), for: .horizontal)
        
        NSLayoutConstraint.activate([
            artworkImageView.centerXAnchor.constraint(equalTo: artworkView.centerXAnchor),
            artworkImageView.centerYAnchor.constraint(equalTo: artworkView.centerYAnchor),
            artworkImageView.widthAnchor.constraint(lessThanOrEqualTo: artworkView.widthAnchor),
            artworkImageView.heightAnchor.constraint(lessThanOrEqualTo: artworkView.heightAnchor),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor)
        ])
        
        let leadingConstraint = artworkImageView.leadingAnchor.constraint(
            equalTo: artworkView.leadingAnchor)
        
        leadingConstraint.priority = UILayoutPriority(750)
        leadingConstraint.isActive = true
        
        let trailingConstraint = artworkImageView.trailingAnchor.constraint(
            equalTo: artworkView.trailingAnchor)

        trailingConstraint.priority = UILayoutPriority(750)
        trailingConstraint.isActive = true
        
        let topConstrain = artworkImageView.topAnchor.constraint(
            equalTo: artworkView.topAnchor)
        
        topConstrain.priority = UILayoutPriority(750)
        topConstrain.isActive = true
        
        let bottomConstraint = artworkImageView.bottomAnchor.constraint(
            equalTo: artworkView.bottomAnchor)

        bottomConstraint.priority = UILayoutPriority(750)
        bottomConstraint.isActive = true
    }
    
    // MARK: InfoView
    
    func setupInfoViewLayout() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
    }
    
    func setupSliderLayout() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            slider.centerYAnchor.constraint(equalTo: currentTimeLabel.centerYAnchor),
            slider.leadingAnchor.constraint(
                equalTo: currentTimeLabel.trailingAnchor,
                constant: Metrics.sliderHorizontalSpace),
            slider.heightAnchor.constraint(equalToConstant: Metrics.sliderHeight)
        ])
    }
    
    func setupCurrentTimeLabelLayout() {
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            currentTimeLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            currentTimeLabel.leadingAnchor.constraint(
                equalTo: infoView.leadingAnchor,
                constant: Metrics.artworkImageViewHorizontalSpace),
            currentTimeLabel.heightAnchor.constraint(equalToConstant: Metrics.timersHeight),
            currentTimeLabel.widthAnchor.constraint(equalToConstant: Metrics.timersWidth)
        ])
    }
    
    func setupDurationLabelLayout() {
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            durationLabel.leadingAnchor.constraint(
                equalTo: slider.trailingAnchor,
                constant: Metrics.sliderHorizontalSpace),
            durationLabel.trailingAnchor.constraint(
                equalTo: infoView.trailingAnchor,
                constant: -Metrics.artworkImageViewHorizontalSpace),
            durationLabel.heightAnchor.constraint(equalToConstant: Metrics.timersHeight),
            durationLabel.widthAnchor.constraint(equalToConstant: Metrics.timersWidth)
        ])
    }
    
    // MARK: SoundIconNameView
    
    func setupSoundIconNameView() {
        soundIconNameView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            soundIconNameView.topAnchor.constraint(
                equalTo: slider.bottomAnchor,
                constant: Metrics.artworkImageViewBottomSpace),
            soundIconNameView.bottomAnchor.constraint(
                equalTo: infoView.bottomAnchor,
                constant: -Metrics.infoViewBottomSpace),
            soundIconNameView.heightAnchor.constraint(equalToConstant: nameLabel.font.pointSize - 2),
            soundIconNameView.widthAnchor.constraint(lessThanOrEqualTo: slider.widthAnchor),
            soundIconNameView.centerXAnchor.constraint(equalTo: slider.centerXAnchor)
        ])
    }
    
    func setupSoundIconImageViewLayout() {
        soundIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            soundIconImageView.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            soundIconImageView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            soundIconImageView.leadingAnchor.constraint(equalTo: soundIconNameView.leadingAnchor),
            soundIconImageView.heightAnchor.constraint(equalToConstant: nameLabel.font.pointSize - 2),
            soundIconImageView.widthAnchor.constraint(equalToConstant: nameLabel.font.pointSize - 2)
        ])
    }
    
    func setupTrackNameLabelLayout() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: soundIconNameView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: soundIconNameView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: soundIconImageView.trailingAnchor,
                constant: Metrics.artworkImageViewTopSpace),
            nameLabel.trailingAnchor.constraint(equalTo: soundIconNameView.trailingAnchor)
        ])
    }
    
    // MARK: ControllerView
    
    func setupControllerViewLayout() {
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        controllerView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            controllerView.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            controllerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            controllerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            controllerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: VolumeView
    
    func setupVolumeViewLayout() {
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            volumeView.topAnchor.constraint(equalTo: controllerView.topAnchor, constant: Metrics.volumeViewTopSpace),
            volumeView.leadingAnchor.constraint(
                equalTo: controllerView.leadingAnchor,
                constant: Metrics.volumeViewHorizontalSpace),
            volumeView.trailingAnchor.constraint(
                equalTo: controllerView.trailingAnchor,
                constant: -Metrics.volumeViewHorizontalSpace),
            volumeView.heightAnchor.constraint(equalToConstant: Metrics.volumeViewHeight)
        ])
    }
    
    func setupVolumeMinButtonLayout() {
        volumeMinButton.translatesAutoresizingMaskIntoConstraints = false
        volumeMinButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            volumeMinButton.centerYAnchor.constraint(equalTo: volumeView.centerYAnchor),
            volumeMinButton.leadingAnchor.constraint(equalTo: volumeView.leadingAnchor),
            volumeMinButton.heightAnchor.constraint(equalToConstant: Metrics.volumeMinMaxHeight),
            volumeMinButton.widthAnchor.constraint(equalToConstant: Metrics.volumeMinMaxWidth)
        ])
    }
    
    func setupVolumeSliderLayout() {
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            volumeSlider.centerYAnchor.constraint(equalTo: volumeView.centerYAnchor),
            volumeSlider.leadingAnchor.constraint(
                equalTo: volumeMinButton.trailingAnchor,
                constant: Metrics.volumeSliderHorizontalSpace)
        ])
    }
    
    func setupVolumeMaxButtonLayout() {
        volumeMaxButton.translatesAutoresizingMaskIntoConstraints = false
        volumeMaxButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            volumeMaxButton.centerYAnchor.constraint(equalTo: volumeView.centerYAnchor),
            volumeMaxButton.leadingAnchor.constraint(
                equalTo: volumeSlider.trailingAnchor,
                constant: Metrics.volumeSliderHorizontalSpace),
            volumeMaxButton.trailingAnchor.constraint(equalTo: volumeView.trailingAnchor),
            volumeMaxButton.heightAnchor.constraint(equalToConstant: Metrics.volumeMinMaxHeight),
            volumeMaxButton.widthAnchor.constraint(equalToConstant: Metrics.volumeMinMaxHeight)
        ])
    }
    
    // MARK: ButtonsView
    
    func setupButtonsViewLayout() {
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: volumeView.bottomAnchor, constant: Metrics.volumeViewBottomSpace),
            buttonsView.centerXAnchor.constraint(equalTo: controllerView.centerXAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: Metrics.playButtonSize)
        ])
        
        let bottomConstrain = buttonsView.bottomAnchor.constraint(
            lessThanOrEqualTo: controllerView.bottomAnchor,
            constant: -Metrics.artworkImageViewTopSpace)

        bottomConstrain.isActive = true
    }
    
    func setupPlayButtonLayout() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            playButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            playButton.leadingAnchor.constraint(
                equalTo: previousTrackButton.trailingAnchor,
                constant: Metrics.playButtonHorizontalSpace),
            playButton.heightAnchor.constraint(equalToConstant: Metrics.playButtonSize),
            playButton.widthAnchor.constraint(equalToConstant: Metrics.playButtonSize)
        ])
    }
    
    func setupPreviousTrackButtonLayout() {
        previousTrackButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previousTrackButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            previousTrackButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            previousTrackButton.heightAnchor.constraint(equalToConstant: Metrics.previousNextButtonSize),
            previousTrackButton.widthAnchor.constraint(equalToConstant: Metrics.previousNextButtonSize)
        ])
    }
    
    func setupNextTrackButtonLayout() {
        nextTrackButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextTrackButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            nextTrackButton.leadingAnchor.constraint(
                equalTo: playButton.trailingAnchor,
                constant: Metrics.playButtonHorizontalSpace),
            nextTrackButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            nextTrackButton.heightAnchor.constraint(equalToConstant: Metrics.previousNextButtonSize),
            nextTrackButton.widthAnchor.constraint(equalToConstant: Metrics.previousNextButtonSize)
        ])
    }
}

// MARK: - Actions

private extension TrackDetailView {
    func setupActions() {
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        previousTrackButton.addTarget(self, action: #selector(didTapPreviousTrackButton), for: .touchUpInside)
        nextTrackButton.addTarget(self, action: #selector(didTapNextTrackButton), for: .touchUpInside)
        
        volumeMinButton.addTarget(self, action: #selector(didTapVolumeMinButton), for: .touchUpInside)
        volumeMaxButton.addTarget(self, action: #selector(didTapVolumeMaxButton), for: .touchUpInside)
        
        volumeSlider.addTarget(self, action: #selector(didChangeVolumeSliderValue(_:)), for: .valueChanged)
    }
    
    @objc
    func didTapPlayButton() {
        switch playButtonState {
        case .start:
            playButtonState = .stop
            
            delegate?.trackDetailViewDidTapStartButton(self)
        case .stop:
            playButtonState = .start
            
            delegate?.trackDetailViewDidTapStopButton(self)
        }
        
        setupPlayButtonAppearance()
    }
    
    @objc
    func didChangeVolumeSliderValue(_ slider: UISlider) {
        delegate?.trackDetailViewDidChangeVolumeSlider(self, value: slider.value)
    }
    
    @objc
    func didTapPreviousTrackButton() {
        delegate?.trackDetailViewDidTapPreviousTrackButton(self)
    }
    
    @objc
    func didTapNextTrackButton() {
        delegate?.trackDetailViewDidTapNextTrackButton(self)
    }
    
    @objc
    func didTapVolumeMinButton() {
        volumeSlider.setValue(0, animated: false)
        
        delegate?.trackDetailViewDidTapVolumeMinButton(self)
    }
    
    @objc
    func didTapVolumeMaxButton() {
        volumeSlider.setValue(1, animated: false)
        
        delegate?.trackDetailViewDidTapVolumeMaxButton(self)
    }
}

// MARK: - CustomSliderDelegate

extension TrackDetailView: CustomSliderDelegate {
    func customSlider(_ customSlider: CustomSlider, didTapTrackWithValue value: CGFloat) {
        delegate?.trackDetailViewDidChangeSlider(self, value: Float(slider.value))
    }
    
    func customSliderDidEndTracking(_ customSlider: CustomSlider) {
        delegate?.trackDetailViewDidChangeSlider(self, value: Float(slider.value))
    }
}
