//
//  PlaceModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 31/12/24.
//

struct PlaceModel: Codable, Hashable {
    let country: String
    let name: String
    let coordinate: CoordinateModel
    let isFavorite: Bool
    
    var id: String {
        "\(country),\(name),\(coordinate.lat),\(coordinate.lon)"
    }
    
    var prefixSearch: String {
        "\(name), \(country)".lowercased()
    }
    
    init(
        country: String,
        name: String,
        coordinate: CoordinateModel,
        isFavorite: Bool = false
    ) {
        self.country = country
        self.name = name
        self.coordinate = coordinate
        self.isFavorite = isFavorite
    }
    
    init(from DTO: PlaceDTO) {
        self.country = DTO.country
        self.name = DTO.name
        self.coordinate = CoordinateModel(from: DTO.coordinate)
        self.isFavorite = false
    }
    
    init(from entity: PlaceEntity) {
        self.country = entity.country
        self.name = entity.name
        self.coordinate = CoordinateModel(lon: entity.lon, lat: entity.lon)
        self.isFavorite = false
    }
}
