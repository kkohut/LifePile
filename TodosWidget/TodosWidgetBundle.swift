//
//  TodosWidgetBundle.swift
//  TodosWidget
//
//  Created by Kevin Kohut on 11.07.23.
//

import WidgetKit
import SwiftUI

@main
struct TodosWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodosWidget()
        TodosWidgetLiveActivity()
    }
}
