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
            case "Housekeeping": "house"
            case "University": "graduationcap"
            case "Work": "suitcase"
            case "Social": "figure.socialdance"
            case "Sports": "dumbbell"
            default: nil
        }
    }
}
