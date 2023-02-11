//
//  ContentView.swift
//  CinderBlock
//
//  Created by Hariz Shirazi on 2023-02-11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Button (
                    action: {
                        print("Not Implemented")
                    },
                    label: {
                        Text("Oh yeah. Brick it.")
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
