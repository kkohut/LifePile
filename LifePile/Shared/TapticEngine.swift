//
//  TapticEngine.swift
//  LifePile
//
//  Created by Kevin Kohut on 01.05.23.
//

#if os(iOS)
import UIKit.UIImpactFeedbackGenerator
#endif
import Dependencies

struct TapticEngine {
    func lightFeedback() {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }
    
    func mediumFeedback() {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }
    
    func heavyFeedback() {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        #endif
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
