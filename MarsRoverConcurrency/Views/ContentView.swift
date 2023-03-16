//
//  ContentView.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MarsRoverViewModel()
    var body: some View {
        TabView {
            LatestPhotosView()
              .tabItem {
                Label("Latest", systemImage: "video.fill")
              }
            
            RoversListView()
                .tabItem {
                    Label("Browse", systemImage: "globe")
                }
        }
        .environmentObject(viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
