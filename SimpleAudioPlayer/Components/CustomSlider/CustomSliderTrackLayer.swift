//
//  CustomSliderTrackLayer.swift
//  SimpleAudioPlayer
//
//  Created by admin on 13.05.2021.
//

import UIKit

final class CustomSliderTrackLayer: CALayer {
    // MARK: Properties
    
    weak var customSlider: CustomSlider?
    
    // MARK: Lifecycle
    
    override func draw(in ctx: CGContext) {
        guard let customSlider = customSlider else {
            return
        }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(customSlider.trackTintColor.cgColor)
        ctx.fillPath()
        
        ctx.setFillColor(customSlider.trackHighlightTintColor.cgColor)
        
        let minimumValuePosition = customSlider.positionForValue(customSlider.minimumValue)
        let valuePosition = customSlider.positionForValue(customSlider.value)
        let rect = CGRect(
            x: minimumValuePosition,
            y: 0,
            width: valuePosition - minimumValuePosition,
            height: bounds.height)
        
        ctx.fill(rect)
    }
}
