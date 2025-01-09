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
    var isFavorite: Bool
    
    var id: String {
        "\(country),\(name),\(coordinate.latitude),\(coordinate.longitude)"
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
        self.coordinate = CoordinateModel(
            latitude: entity.latitude,
            longitude: entity.longitude
        )
        self.isFavorite = entity.isFavorite
    }
    
    init(from locationViewModel: LocationViewModel) {
        self.country = locationViewModel.country
        self.name = locationViewModel.name
        self.coordinate = CoordinateModel(
            latitude: locationViewModel.latitude,
            longitude: locationViewModel.longitude
        )
        self.isFavorite = locationViewModel.isFavorite
    }
}
