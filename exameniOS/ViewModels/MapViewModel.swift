//
//  MapViewModel.swift
//  exameniOsVictorGarcia
//
//  Created by Victor Garcia on 21/11/24.
//


import Foundation
import FirebaseDatabase
import CoreLocation

class MapViewModel {
    private let database = Database.database().reference(fromURL: "https://examenios-1d8bd-default-rtdb.firebaseio.com/")
    // Guardar ubicación en Firebase
    func saveCoordinate(username: String, location: CLLocation) {
        let coordinateData: [String: Any] = [
            "username": username,
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": ServerValue.timestamp() // Para almacenar la hora en que se guardó
        ]
        
        database.child("locations").childByAutoId().setValue(coordinateData)
    }
    
    // Obtener historial de ubicaciones desde Firebase
    func fetchCoordinates(completion: @escaping ([Coordinate]) -> Void) {
        database.child("locations").observe(.value) { snapshot in
            var coordinates: [Coordinate] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let username = value["username"] as? String,
                   let latitude = value["latitude"] as? Double,
                   let longitude = value["longitude"] as? Double {
                    let coordinate = Coordinate(username: username, latitude: latitude, longitude: longitude)
                    coordinates.append(coordinate)
                }
            }
            
            completion(coordinates)
        }
    }
}

