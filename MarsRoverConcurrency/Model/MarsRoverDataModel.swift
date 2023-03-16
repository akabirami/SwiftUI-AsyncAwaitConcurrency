//
//  MarsRoverDataModel.swift
//  MarsRoverConcurrency
//
//  Created by Abirami Kalyan on 15/03/2023.
//

import Foundation

// MARK: - RoverImages
struct RoverImages: Codable {
    let latestPhotos: [LatestPhoto]

    enum CodingKeys: String, CodingKey {
        case latestPhotos = "latest_photos"
    }
}

// MARK: - RoverPhotos
struct RoverPhotos: Codable {
    let photos: [LatestPhoto]
}

// MARK: - Rovers
struct Rovers: Codable {
    let rovers: [Rover]
}

// MARK: - Rover
struct Rover: Codable {
    let id: Int
    let name, landingDate, launchDate, status: String
    let maxSol: Int?
    let maxDate: String?
    let totalPhotos: Int?
    let cameras: [Camera]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case cameras
    }
}

// MARK: - Camera
struct Camera: Codable {
    let id: Int
    let name: String
    let roverID: Int
    let fullName: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case roverID = "rover_id"
        case fullName = "full_name"
    }
}

// MARK: - LatestPhoto
struct LatestPhoto: Codable {
    let id, sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover

    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

// MARK: - Manifest
struct Manifest: Codable {
    let photoManifest: PhotoManifest

    enum CodingKeys: String, CodingKey {
        case photoManifest = "photo_manifest"
    }
}

// MARK: - PhotoManifest
struct PhotoManifest: Codable {
    let name, landingDate, launchDate, status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let photos: [Photo]

    enum CodingKeys: String, CodingKey {
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case photos
    }
}

// MARK: - Photo
struct Photo: Codable {
    let sol: Int
    let earthDate: String
    let totalPhotos: Int
    let cameras: [String]

    enum CodingKeys: String, CodingKey {
        case sol
        case earthDate = "earth_date"
        case totalPhotos = "total_photos"
        case cameras
    }
}

extension DateFormatter {
    static func marsDateFormatter(dateString: String) -> Date? {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      let date = formatter.date(from: dateString)
      return date
    }
}
