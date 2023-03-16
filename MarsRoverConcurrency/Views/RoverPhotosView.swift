//
//  RoverPhotosView.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import SwiftUI

struct RoverPhotosView: View {
    @EnvironmentObject var viewModel: MarsRoverViewModel
    var roverName: String
    var sol: Int
    @State private var photos = [LatestPhoto]()
    let columns = [
        GridItem(.flexible()),
    ]
    
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                ForEach(photos, id: \.self.id) { photo in
                    MarsRoverPhotoView(photo: photo)
                }
            }
        }
        .task {
            do {
                photos = try await viewModel.fetchRoverPhoto(for: roverName, sol: sol)
                print(photos.count)
            } catch {
                print("error: \(error)")
            }
        }
    }
}

struct RoverPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        RoverPhotosView(roverName: "perseverance", sol: 1)
    }
}
