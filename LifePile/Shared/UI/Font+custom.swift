//
//  Font+custom.swift
//  LifePile
//
//  Created by Kevin Kohut on 15.05.23.
//

import SwiftUI
import Foundation

extension Font {
    private static let customFont = "GillSans"
    static let largeTitle = Font.custom(customFont, size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    static let headline = Font.custom(customFont, size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
    static let body = Font.custom(customFont, size: UIFont.preferredFont(forTextStyle: .body).pointSize)
}
