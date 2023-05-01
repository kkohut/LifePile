//
//  TapticEngine.swift
//  LifePile
//
//  Created by Kevin Kohut on 01.05.23.
//

import UIKit.UIImpactFeedbackGenerator

struct TapticEngine {
    func lightFeedback() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func mediumFeedback() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}
