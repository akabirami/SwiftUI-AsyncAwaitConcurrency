//
//  LatestPhotoView.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import SwiftUI

struct LatestPhotosView: View {
    
    @EnvironmentObject var viewModel: MarsRoverViewModel
    @State var latestPhotos = [LatestPhoto]()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(latestPhotos, id: \.self.id) { photo in
                            MarsRoverPhotoView(photo: photo)
                        }
                    }
                }
                
                if latestPhotos.isEmpty {
                    ProgressView()
                }
            }
            .navigationTitle("Latest Photos")
            .task {
                latestPhotos = []
                do {
                    latestPhotos = try await viewModel.fetchAllRoverImages()
                } catch {
                    print("Request failed error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    @ViewBuilder func makeRoverImage(imageUrl: String) -> some View {
        AsyncImage(url: URL(string: imageUrl)) { phaseImage in
            switch(phaseImage) {
            case .empty:
                ProgressView()
            case.success(let image):
                image
                    .resizable()
            case.failure(let error):
                VStack {
                  Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                  Text(error.localizedDescription)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                }
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 350, height: 300)
        .padding([.leading, .trailing], 20)
    }
}

struct LatestPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        LatestPhotosView()
    }
}
