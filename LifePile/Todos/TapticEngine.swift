//
//  TapticEngine.swift
//  LifePile
//
//  Created by Kevin Kohut on 01.05.23.
//

import UIKit.UIImpactFeedbackGenerator
import Dependencies

struct TapticEngine {
    func lightFeedback() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func mediumFeedback() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

extension DependencyValues {
    var tapticEngine: TapticEngine {
        get { self[TapticEngineKey.self] }
        set { self[TapticEngineKey.self] = newValue }
    }
}

private enum TapticEngineKey: DependencyKey {
    static let liveValue = TapticEngine()
}
