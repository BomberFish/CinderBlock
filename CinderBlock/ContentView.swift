//
//  ContentView.swift
//  CinderBlock
//
//  Created by Hariz Shirazi on 2023-02-11.
//

import SwiftUI

struct ContentView: View {
    @State var success = false
    var body: some View {
        NavigationView {
            List {
                Button (
                    action: {
                        success = brick()
                    },
                    label: {
                        Label("Oh yeah. Brick it.", systemImage: "arrow.right.circle")
                    }
                )
            }
            .navigationTitle("CinderBlock")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
