//
//  RoversListView.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import SwiftUI

struct RoversListView: View {
    @EnvironmentObject var viewModel: MarsRoverViewModel
    @State private var manifestList = [PhotoManifest]()
    var body: some View {
        NavigationStack {
            ZStack {
                List(manifestList, id: \.self.name) { manifest in
                    NavigationLink {
                        RoverManifestView(manifest: manifest)
                    } label: {
                        HStack {
                            Text("\(manifest.name) - \(manifest.status)")
                            Spacer()
                            Text("\(manifest.totalPhotos) \(Image(systemName: "photo"))")
                        }
                    }
                }
                .task {
                    manifestList = []
                    do {
                        manifestList = try await viewModel.fetchAllPhotoManifests()
                    } catch {
                        print("Error : \(error)")
                    }
                }
                .refreshable {
                    manifestList = []
                    do {
                        manifestList = try await viewModel.fetchAllPhotoManifests()
                    } catch {
                        print("Error : \(error)")
                    }
                }
                
                if manifestList.isEmpty {
                    ProgressView()
                }
            }
            .padding(.top, 20)
            .navigationTitle("Mars Rovers")
            .scrollContentBackground(.hidden)
        }
    }
}

struct RoversListView_Previews: PreviewProvider {
    static var previews: some View {
        RoversListView()
    }
}
