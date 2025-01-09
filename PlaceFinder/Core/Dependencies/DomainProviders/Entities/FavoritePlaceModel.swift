//
//  FavoritePlaceModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//

struct FavoritePlaceModel: Hashable {
    let country: String
    let name: String
    let coordinate: CoordinateModel
    
    var uniqueID: String {
        "\(name),\(country),\(coordinate.latitude),\(coordinate.longitude)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueID)
    }
    
    static func == (lhs: FavoritePlaceModel, rhs: FavoritePlaceModel) -> Bool {
        lhs.uniqueID == rhs.uniqueID
    }
    
    init(from entity: PlaceEntity) {
        self.country = entity.country
        self.name = entity.name
        self.coordinate = CoordinateModel(
            latitude: entity.latitude,
            longitude: entity.longitude
        )
    }
    
    init(from placeModel: PlaceModel) {
        self.country = placeModel.country
        self.name = placeModel.name
        self.coordinate = placeModel.coordinate
    }
}
