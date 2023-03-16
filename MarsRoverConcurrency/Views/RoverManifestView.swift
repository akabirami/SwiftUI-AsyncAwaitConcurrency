//
//  RoverManifestView.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import SwiftUI

struct RoverManifestView: View {
    var manifest: PhotoManifest
    var body: some View {
        NavigationStack {
            List(manifest.photos, id: \.self.sol) { photo in
                NavigationLink {
                    RoverPhotosView(roverName: manifest.name, sol: photo.sol)
                } label: {
                    manifestCellView(for: photo)
                }
            }
        }
    }
    
    @ViewBuilder func manifestCellView(for photo: Photo) -> some View {
        HStack {
            Text("Sol\(photo.sol)")
            Text(DateFormatter.marsDateFormatter(dateString: photo.earthDate) ?? Date(), style: .date)
            Spacer()
            Text("\(photo.totalPhotos) \(Image(systemName: "photo"))")
        }
    }
}

struct RoverManifestView_Previews: PreviewProvider {
    static var previews: some View {
        RoverManifestView(manifest:
                            PhotoManifest(
                              name: "WALL-E",
                              landingDate: "2021-12-31",
                              launchDate: "2021-12-01",
                              status: "active",
                              maxSol: 31,
                              maxDate: "2022-01-31",
                              totalPhotos: 33,
                              photos: [
                                Photo(
                                  sol: 1,
                                  earthDate: "2022-01-01",
                                  totalPhotos: 33,
                                  cameras: []
                                )
                              ]
                            )
                          )
    }
}
