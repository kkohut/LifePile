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
}
