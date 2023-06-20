//
//  Color+custom.swift
//  LifePile
//
//  Created by Kevin Kohut on 15.05.23.
//

import SwiftUI
import Foundation

extension Color {
    enum Custom: String, View {
        case background = "Background"
        
        var body: some View {
            Color(self.rawValue)
        }
    }
    
    static func from(tag: TagDTO?) -> Color {
        guard let tag else {
            return .accentColor
        }
        
        var hash = 0
        let colorConstant = 131
        let maxSafeValue = Int.max / colorConstant
        
        for char in tag.title.unicodeScalars {
            if hash > maxSafeValue {
                hash = hash / colorConstant
            }
            hash = Int(char.value) + ((hash << 5) - hash)
        }
        
        let finalHash = abs(hash) % (256 * 256 * 256);
        let uiColor = UIColor(red: CGFloat((finalHash & 0xFF0000) >> 16) / 255.0,
                              green: CGFloat((finalHash & 0xFF00) >> 8) / 255.0,
                              blue: CGFloat((finalHash & 0xFF)) / 255.0, alpha: 0.5)
        return Color(uiColor)
    }
}
