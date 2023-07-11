//
//  TodoUserDefaults.swift
//  LifePile
//
//  Created by Kevin Kohut on 11.07.23.
//

import Foundation
import Dependencies

struct TodoUserDefaults {
    func saveCountAndWeight(count: Int, totalWeight: Int) {
        if let userDefaults = UserDefaults(suiteName: "group.lifepile") {
            userDefaults.set(count, forKey: "todoCount")
            userDefaults.set(totalWeight, forKey: "todoTotalWeight")
        }
    }
}

extension DependencyValues {
    var todoUserDefaults: TodoUserDefaults {
        get { self[TodoUserDefaultsKey.self] }
        set { self[TodoUserDefaultsKey.self] = newValue }
    }
}

private enum TodoUserDefaultsKey: DependencyKey {
    static let liveValue = TodoUserDefaults()
}
