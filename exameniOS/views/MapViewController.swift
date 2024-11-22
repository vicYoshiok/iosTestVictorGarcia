//
//  MapViewController.swift
//  exameniOsVictorGarcia
//
//  Created by Victor Garcia on 21/11/24.
//
import UIKit
import MapKit
import CoreLocation
import Firebase
import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private let locationManager = CLLocationManager()
    private let viewModel = MapViewModel()
    var user: String?
    private var coordinates: [Coordinate] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        
        if let user = user {
            self.userLabel.text = user
        } else {
            self.userLabel.text = "Usuario default"
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Obtiene las coordenadas guardadas desde Firebase
        viewModel.fetchCoordinates { [weak self] coordinates in
            self?.coordinates = coordinates
            self?.tableView.reloadData()
        }
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func displayCoordinates(_ coordinates: [Coordinate]) {
        for coordinate in coordinates {
            let annotation = MKPointAnnotation()
            annotation.title = coordinate.username
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            mapView.addAnnotation(annotation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Mostrar la ubicación actual en el mapa
        let currentCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "ubicación actual"
        annotation.coordinate = currentCoordinate
        mapView.addAnnotation(annotation)
        
        viewModel.saveCoordinate(username: self.userLabel.text!, location: location)
        
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    // MARK: - table view y metodos

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coordinates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let coordinate = coordinates[indexPath.row]
        cell.textLabel?.text = coordinate.username
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinate = coordinates[indexPath.row]
        let selectedCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        

        let region = MKCoordinateRegion(center: selectedCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = coordinate.username
        annotation.coordinate = selectedCoordinate
        mapView.addAnnotation(annotation)
    }
}
