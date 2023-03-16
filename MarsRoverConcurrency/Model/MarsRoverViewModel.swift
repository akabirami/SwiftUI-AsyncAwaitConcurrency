//
//  MarsRoverViewModel.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import SwiftUI

class MarsRoverViewModel: ObservableObject {
    
    private let requestHandlerModel = MarsRequestHandlerModel()
    
    func fetchAllRovers() async throws -> [Rover] {
        return try await requestHandlerModel.fetchAllRovers()
    }
    
    func fetchAllRoverImages() async throws -> [LatestPhoto] {
        // First fetch all rovers
        // For each rover fetch the images
        // map all first images and return the result
        
        // We use task group to simplify this
        
        let latestPhotos = try await withThrowingTaskGroup(of: LatestPhoto?.self, returning: [LatestPhoto].self) { group in
            let rovers = try await fetchAllRovers()
            
            for rover in rovers {
                group.addTask {
                    let photos = try await self.requestHandlerModel.fetchLatestPhotos(roverName: rover.name)
                    return photos.first
                }
            }
            
            var latestPhotos = [LatestPhoto]()
            for try await result in group {
                if let photo = result {
                    latestPhotos.append(photo)
                }
            }
            
            return latestPhotos
        }
        
        return latestPhotos
    }
    
    func fetchAllRoverImagesAlt() async throws -> [LatestPhoto] {
         //This is one approach to use concurrent binding
        async let curiosityPhotos = requestHandlerModel.fetchLatestPhotos(roverName: "curiosity")
        async let perseverancePhotos = requestHandlerModel.fetchLatestPhotos(roverName: "perseverance")
        async let spiritPhotos = requestHandlerModel.fetchLatestPhotos(roverName: "spirit")
        async let opportunityPhotos = requestHandlerModel.fetchLatestPhotos(roverName: "opportunity")

        let result = try await [
            curiosityPhotos.first,
            perseverancePhotos.first,
            spiritPhotos.first,
            opportunityPhotos.first
        ]

        return result.compactMap { $0 }
    }
    
    func fetchAllPhotoManifests() async throws -> [PhotoManifest] {
        let rovers = try await fetchAllRovers()
        
        let manifestDict = try await withThrowingTaskGroup(of: (PhotoManifest).self) { group in
            
            for rover in rovers {
                group.addTask{
                    try await self.requestHandlerModel.fetchPhotoManifest(rover: rover)
                }
            }
            
            var manifiests = [PhotoManifest]()
            for try await result in group {
                manifiests.append(result)
            }
            
            return manifiests
        }
        return manifestDict
    }
    
    func fetchRoverPhoto(for roverName: String, sol: Int) async throws -> [LatestPhoto] {
        return try await requestHandlerModel.fetchPhotos(roverName: roverName, sol: sol)
    }
    
}
