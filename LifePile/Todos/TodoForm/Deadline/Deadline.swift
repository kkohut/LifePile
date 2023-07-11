//
//  Deadline.swift
//  LifePile
//
//  Created by Kevin Kohut on 07.07.23.
//

import Foundation
import ComposableArchitecture

struct Deadline: ReducerProtocol {
    struct State: Equatable {
        @BindingState var date: Date = Date()
//        let id = UUID()
//        @BindingState var text: String = ""
    }
    
    enum Action: Equatable, Sendable {
        case dateChanged(date: Date)
//        case deleteDeadlineButtonTapped
//        case binding(BindingAction<State>)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocolOf<Self> {
        
        //        BindingReducer(action: /Action.view)
        Reduce { state, action in
            switch action {
                            case .dateChanged(let date):
                                state.date = date
                                return .none
                                
                //            case .deleteDeadlineButtonTapped:
                //                return .none
                ////            case .binding(\.$date):
                ////                
                ////                return .none
                //            case .binding(\.$text):
                //                return .none
                //                
                //            case .binding:
                //                return .none
                //            }
            case .binding:
                print("Binding changed")
                return .none
            }
        }
    }
}
