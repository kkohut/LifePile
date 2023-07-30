//
//  SystemImageKeys.swift
//  LifePile
//
//  Created by Kevin Kohut on 25.06.23.
//

import Foundation

enum SystemImageKey {
    static func from(tagTitle: String?) -> String? {
        switch tagTitle {
            case "Housekeeping": return "house"
            case "Study": return "graduationcap"
            case "Work": return "suitcase"
            case "Social": return "figure.socialdance"
            case "Sports": return "dumbbell"
            case "Hobbies": return "paintpalette"
            default: return nil
        }
    }
}
