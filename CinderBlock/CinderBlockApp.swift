//
//  CinderBlockApp.swift
//  CinderBlock
//
//  Created by Hariz Shirazi on 2023-02-11.
//

import SwiftUI

@main
struct CinderBlockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    if #available(iOS 16.2, *) {
#if targetEnvironment(simulator)
#else
                        // I'm sorry 16.2 dev beta 1 users, you are a vast minority.
                        print("Throwing not supported error (patched)")
                        UIApplication.shared.alert(title: "Not Supported", body: "This version of iOS is not supported.", withButton: false)
#endif
                    } else {
                        do {
                            // TrollStore method
                            print("Checking if installed with TrollStore...")
                            try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: "/var/mobile/Library/Caches"), includingPropertiesForKeys: nil)
                        } catch {
                            // MDC method
                            // grant r/w access
                            if #available(iOS 15, *) {
                                print("Trying sandbox escape...")
                                grant_full_disk_access() { error in
                                    if (error != nil) {
                                        print("Unable to escape sandbox! Error: ", String(describing: error?.localizedDescription ?? "unknown?!"))
                                        UIApplication.shared.alert(title: "Access Error", body: "Error: \(String(describing: error?.localizedDescription))\nPlease close the app and retry.", withButton: false)
                                    }
                                }
                            } else {
                                print("Throwing not supported error (too old)")
                                UIApplication.shared.alert(title: "Exploit Not Supported", body: "Please install via TrollStore")
                            }
                        }
                    }
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let url = URL(string: "https://api.github.com/repos/BomberFish/CinderBlock/releases/latest") {
                        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                            guard let data = data else { return }
                            
                            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                                if (json["tag_name"] as? String)?.replacingOccurrences(of: "v", with: "").compare(version, options: .numeric) == .orderedDescending {
                                    UIApplication.shared.confirmAlert(title: "Update available!", body: "A new app update is available, do you want to visit the releases page?", onOK: {
                                        UIApplication.shared.open(URL(string: "https://github.com/BomberFish/CinderBlock/releases/latest")!)
                                    }, noCancel: false)
                                }
                            }
                        }
                        task.resume()
                    }
                }
        }
    }
}
