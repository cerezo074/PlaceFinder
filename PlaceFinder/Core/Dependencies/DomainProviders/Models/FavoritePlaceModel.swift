//
//  FavoritePlaceModel.swift
//  PlaceFinder
//
//  Created by Eli Pacheco Hoyos on 9/01/25.
//

struct FavoritePlaceModel: Hashable, ModelIDs {
    let country: String
    let name: String
    let coordinate: CoordinateModel
    
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
    
    init?(from uniqueID: String) {
        let components = uniqueID.split(separator: ",")
        
        guard components.count == 4,
              let latitude = Double(components[2]),
              let longitude = Double(components[3]) else {
            return nil
        }
        
        self.name = String(components[0])
        self.country = String(components[1])
        self.coordinate = CoordinateModel(latitude: latitude, longitude: longitude)
    }
}
