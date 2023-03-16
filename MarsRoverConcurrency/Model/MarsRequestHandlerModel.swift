//
//  MarsRequestHandlerModel.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import Foundation

class MarsRequestHandlerModel {
    enum RequestError: Error {
      case requestURLInvalid(String?)
      case failed
    }

    // https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/latest_photos?api_key=DEMO_KEY
    let apiKey = "FKRTJoxfGkorAg7K8U1pVjbxWqmsV9lbieyFV2dM"
    let apiURLBase = "https://api.nasa.gov/mars-photos/api/v1"
    
    func fetchAllRovers() async throws -> [Rover] {
      let apiRequest = APIRequest<Rovers>(urlString: apiURLBase + "/rovers")
      let roverImages = try await sendRequest(apiRequest)
      return roverImages.rovers
    }
    
    func fetchLatestPhotos(roverName: String) async throws -> [LatestPhoto] {
      let apiRequest = APIRequest<RoverImages>(urlString: apiURLBase + "/rovers/\(roverName)/latest_photos")
      let roverImages = try await sendRequest(apiRequest)
      return roverImages.latestPhotos
    }
    
    func fetchPhotos(roverName: String, sol: Int) async throws -> [LatestPhoto] {
      let apiRequest = APIRequest<RoverPhotos>(urlString: apiURLBase + "/rovers/\(roverName)/photos?sol=\(sol)")
      let roverImages = try await sendRequest(apiRequest)
      return roverImages.photos
    }
    
    func fetchPhotoManifest(rover: Rover) async throws -> PhotoManifest {
      let apiRequest = APIRequest<Manifest>(urlString: "\(apiURLBase)/manifests/\(rover.name)")
      let container = try await sendRequest(apiRequest)
      return container.photoManifest
    }
    
    func sendRequest<T: Decodable>(_ apiRequest: APIRequest<T>) async throws  -> T {
        guard var urlComponents = URLComponents(string: apiRequest.urlString) else {
            throw RequestError.requestURLInvalid(apiRequest.urlString)
        }
        let queryItems = (urlComponents.queryItems ?? []) + [URLQueryItem(name: "api_key", value: apiKey)]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            throw RequestError.requestURLInvalid(apiRequest.urlString)
        }
        print(url.absoluteURL)
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RequestError.failed
        }
        return try apiRequest.decodeJSON(data)
    }
}

struct APIRequest<T: Decodable> {
    var urlString: String
    let decodeJSON: (Data) throws -> T
    
    init(urlString: String) {
      self.urlString = urlString
      self.decodeJSON = { data in
        return try JSONDecoder().decode(T.self, from: data)
      }
    }
}

