//
//  ContentView.swift
//  NeonToggleStyleDemo
//
//  Created by Evgeny Mitko on 31/07/2023.
//

import SwiftUI

struct ContentView: View {
    @State var isOn: Bool = false
    
    var body: some View {
        ZStack {
            Color.toggleBG
            
            VStack {
                Toggle(isOn: $isOn) {
                    Text("Toggle")
                }
                .toggleStyle(NeonToggleStyle())
                .scaleEffect(CGSize(width: 3, height: 3))
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}



