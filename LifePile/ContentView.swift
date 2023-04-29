//
//  ContentView.swift
//  LifePile
//
//  Created by Kevin Kohut on 29.04.23.
//

import SwiftUI

struct ContentView: View {
    @State var pile = [
        "Go for a run",
        "Clean windows",
        "Go to the gym",
        "Read"
    ]
    
    @State var offsets = [
        "Go for a run" : CGSize.zero,
        "Clean windows" : CGSize.zero,
        "Go to the gym" : CGSize.zero,
        "Read" : CGSize.zero
    ]
    
    @Namespace var animation
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: { }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add task")
                        .bold()
                }
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .tint(.green)
            
            ForEach(pile, id: \.self) { task in
                HStack {
                    Spacer()
                    
                    Text(task)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.blue))
                        .offset(x: (offsets[task]!).width)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    offsets[task] = gesture.translation
                                }
                                .onEnded { _ in
                                    if abs(offsets[task]!.width) > 100 {
                                        pile.remove(at: pile.firstIndex(of: task)!)
                                        offsets.removeValue(forKey: task)
                                    } else {
                                        offsets[task] = .zero
                                    }
                                }
                        )
                    
                    Spacer()
                }
            }
        }
        .padding()
        .animation(.spring(), value: offsets)
        .animation(.spring(), value: pile)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
