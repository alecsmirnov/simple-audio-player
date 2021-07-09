//
//  CustomSlider.swift
//  SimpleAudioPlayer
//
//  Created by admin on 13.05.2021.
//

import UIKit

protocol CustomSliderDelegate: AnyObject {
    func customSlider(_ customSlider: CustomSlider, didTapTrackWithValue value: CGFloat)
    func customSliderDidEndTracking(_ customSlider: CustomSlider)
}

final class CustomSlider: UIControl {
    // MARK: - Properties
    
    weak var delegate: CustomSliderDelegate?
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    var minimumValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var maximumValue: CGFloat = 1 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var value: CGFloat {
        get {
            internalValue
        }
        set {
            if isThumbAreaTracked == false {
                internalValue = newValue
            }
        }
    }
    
    var trackTintColor: UIColor = .systemGray {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackHighlightTintColor: UIColor = .black {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    private var internalValue: CGFloat = 0.5 {
        didSet {
            updateLayerFrames()
        }
    }
    
    private var thumbArea: CGRect = .zero
    private var isThumbAreaTracked: Bool = false
    private var previousLocation: CGPoint = .zero
    
    private let thumbAreaSize = CGSize(width: 30, height: 30)
    
    // MARK: - Sublayers
    
    private let trackLayer = CustomSliderTrackLayer()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTrackLayerLayout()
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension CustomSlider {
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
}

// MARK: - Private Methods

private extension CustomSlider {
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(false)
        
        let trackHeight = bounds.height / 3
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: trackHeight)
        trackLayer.setNeedsDisplay()
        
        thumbArea = CGRect(origin: thumbAreaOriginForValue(internalValue), size: thumbAreaSize)
        
        CATransaction.commit()
    }
    
    private func thumbAreaOriginForValue(_ value: CGFloat) -> CGPoint {
        let xPosition = positionForValue(value) - thumbAreaSize.width / 2
        let yPosition = (bounds.height - thumbAreaSize.height) / 2
        
        let position = CGPoint(x: xPosition, y: yPosition)
        
        return position
    }
}

// MARK: - Layer Layout

private extension CustomSlider {
    func setupTrackLayerLayout() {
        trackLayer.customSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        
        layer.addSublayer(trackLayer)
    }
}

// MARK: - Touches

extension CustomSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if thumbArea.contains(previousLocation) {
            isThumbAreaTracked = true
        }
        
        return isThumbAreaTracked
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        
        previousLocation = location
        
        if isThumbAreaTracked {
            internalValue += deltaValue
            internalValue = min(max(internalValue, minimumValue), maximumValue)
        }
        
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isThumbAreaTracked = false
        
        delegate?.customSliderDidEndTracking(self)
    }
}

// MARK: - Gestures

private extension CustomSlider {
    func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSlider(_:)))
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func didTapSlider(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedPoint = tapGestureRecognizer.location(in: self)
        let newValue = tappedPoint.x / bounds.width
        
        internalValue = newValue
        
        delegate?.customSlider(self, didTapTrackWithValue: internalValue)
    }
}
