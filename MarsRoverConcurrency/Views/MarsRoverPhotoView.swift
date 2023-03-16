//
//  MarsRoverPhotoView.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import SwiftUI

struct MarsRoverPhotoView: View {
    var photo: LatestPhoto
    var body: some View {
        AsyncImage(url: URL(string: photo.imgSrc)) { phaseImage in
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
