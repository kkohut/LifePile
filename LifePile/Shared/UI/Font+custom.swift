//
//  Font+custom.swift
//  LifePile
//
//  Created by Kevin Kohut on 15.05.23.
//

import SwiftUI
import Foundation

extension Font {
    static let largeTitle = Font.custom(customFont, size: 34, relativeTo: .largeTitle)
    static let headline = Font.custom(customFont, size: 17, relativeTo: .headline)
    static let body = Font.custom(customFont, size: 17, relativeTo: .body)
    private static let customFont = "GillSans"
}
