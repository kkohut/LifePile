//
//  Font+custom.swift
//  LifePile
//
//  Created by Kevin Kohut on 15.05.23.
//

import SwiftUI
import Foundation

extension Font {
    static let customLargeTitle = Font.custom(customFont, size: 34, relativeTo: .largeTitle)
    static let customHeadline = Font.custom(customFont, size: 17, relativeTo: .headline)
    static let customBody = Font.custom(customFont, size: 17, relativeTo: .body)
    private static let customFont = "GillSans"
}
