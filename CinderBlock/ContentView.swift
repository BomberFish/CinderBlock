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
                Section {
                    Button (
                        action: {
                            success = brick()
                            if success {
                                UIApplication.shared.alert(title: "Probably bricked.", body: "Your phone may or may not be fucked. Reboot to find out! :trol:", withButton: false)
                            } else {
                                UIApplication.shared.alert(title: "Possibly bricked.", body: "Your phone might be fucked. Reboot to find out! :trol:", withButton: false)
                            }
                        },
                        label: {
                            Label("Oh yeah. Brick it.", systemImage: "arrow.right.circle")
                        }
                    )
                }
                Section{}header:{Text("Made with ❤️ by BomberFish")}
            
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
