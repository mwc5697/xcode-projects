//
//  ViewController.swift
//  Campus Walk
//
//  Created by Chung, MINHO on 10/21/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit
import MapKit

class DroppedPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

class FavoredPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var show: Bool
    init(title: String, coordinate: CLLocationCoordinate2D, show:Bool) {
        self.title = title
        self.coordinate = coordinate
        self.show = show
    }
}

enum Option {
    case standard
    case satelite
    case hybrid
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, selectedDelegate, favoriteDelegate, optionDelegate, directionDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var trashDirectionButton: UIButton!
    @IBOutlet weak var infoDirectionButton: UIButton!
    
    
    var buildingsModel = BuildingsModel.sharedInstance
    let spanNumber = 0.01
    var favoredBuildingsList : [FavoredPin] = []
    
    let locationManager = CLLocationManager()
    
    var favoritePin : Bool = true
    //var locationTracking : Bool = false
    var option : Option = .standard
    var addPin : Bool = true
    
    var findUserslocation : Bool = false
    
    var directions : [MKDirections] = []
    var routeDirection : MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = buildingsModel.initialCoordinate
        let span = MKCoordinateSpan(latitudeDelta: spanNumber, longitudeDelta: spanNumber)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
        mapView.delegate = self
        self.navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView:mapView)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //mapView.showsUserLocation = true

        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse:
                mapView.showsUserLocation = true
//              centerViewOnUserLocation()
                //locationManager.startUpdatingLocation()
                //mapView.userTrackingMode = locationTracking ? MKUserTrackingMode.followWithHeading :MKUserTrackingMode.none
                
            default:
                break
            }
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let span = MKCoordinateSpan(latitudeDelta: spanNumber, longitudeDelta: spanNumber)
            let region = MKCoordinateRegion.init(center: location, span: span)

            mapView.setRegion(region, animated: true)
            
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: spanNumber, longitudeDelta: spanNumber)
//        let region = MKCoordinateRegion(center: center, span: span)
//        mapView.setRegion(region, animated: true)
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            mapView.showsUserLocation = false
            
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        switch annotation {
            
        case is DroppedPin:
            return annotationView(forPin: annotation as! DroppedPin)
            
        case is FavoredPin:
            return annotationView(forPin: annotation as! FavoredPin)
            
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(red: 137/255, green: 17/255, blue: 0, alpha: 1)
        renderer.lineWidth = 2.0
        return renderer
    }
    
    func annotationView(forPin droppedPin:DroppedPin) -> MKAnnotationView {
        let pinIdentifier = "DroppedPin"
        
        let pin = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) as? MKPinAnnotationView ??  MKPinAnnotationView(annotation: droppedPin, reuseIdentifier: pinIdentifier)
        pin.pinTintColor = MKPinAnnotationView.redPinColor()
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    
    func annotationView(forPin favoredPin:FavoredPin) -> MKAnnotationView {
        let pinIdentifier = "FavoredPin"
        
        let pin = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) as? MKPinAnnotationView ??  MKPinAnnotationView(annotation: favoredPin, reuseIdentifier: pinIdentifier)
        pin.pinTintColor = MKPinAnnotationView.greenPinColor()
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        switch view.annotation {
        case is DroppedPin:
            let droppedlocation = view.annotation as! DroppedPin
            let alertController = UIAlertController(title:droppedlocation.title, message: nil, preferredStyle: .actionSheet)
            
            let actionAddFavorite = UIAlertAction(title: "Add as Favorite", style: .default) { (action) in
                let name = droppedlocation.title!
                let coordinates = droppedlocation.coordinate
                
                for i in 0..<self.favoredBuildingsList.count{
                    if self.favoredBuildingsList[i].title != name{self.addPin = true}
                    else{self.addPin = false;break}
                }
                if self.addPin{
                    self.favoredBuildingsList.append(FavoredPin(title: name, coordinate: coordinates, show: true))
                }
                self.FavorPin(name: name, latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
            alertController.addAction(actionAddFavorite)
            
            let actionRemove = UIAlertAction(title: "Remove Pin", style: .default) { (action) in
                self.removeOneAnnoation(name: droppedlocation.title!)
            }
            alertController.addAction(actionRemove)
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(actionCancel)
            
            if let presenter = alertController.popoverPresentationController {
                
                presenter.sourceView = view
                presenter.sourceRect = view.bounds
                mapView.deselectAnnotation(view.annotation, animated: true)
                
            }
            
            self.present(alertController, animated: true, completion: nil)
        
        case is FavoredPin:
            let favoredlocation = view.annotation as! FavoredPin
            let alertController = UIAlertController(title:favoredlocation.title, message: "To delete the pin, remove it from favorite first", preferredStyle: .actionSheet)
            
            let actionRemoveFavorite = UIAlertAction(title: "Remove from Favorite", style: .default) { (action) in
                let name = favoredlocation.title!
                let coordinates = favoredlocation.coordinate
                for i in 0..<(self.favoredBuildingsList.count){
                    if self.favoredBuildingsList[i].title == name{
                        self.favoredBuildingsList.remove(at: i)
                        break
                    }
                }
                self.DropPin(name: name, latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
            
            alertController.addAction(actionRemoveFavorite)
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(actionCancel)
            
            if let presenter = alertController.popoverPresentationController {
                
                presenter.sourceView = view
                presenter.sourceRect = view.bounds
                mapView.deselectAnnotation(view.annotation, animated: true)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        
        case "findBuildingSegue":
            let buildingController = segue.destination as! BuildingsTableViewController
            buildingController.delegate = self
        
        case "favoriteBuildingSegue":
            let favoriteController = segue.destination as! FavoritesTableViewController
            favoriteController.delegate = self
            favoriteController.configureWith(buildingList: favoredBuildingsList)
        
        case "optionSegue":
            let optionController = segue.destination as! OptionsTableViewController
            optionController.configureWith(favoritePin: favoritePin, locationManager: locationManager)
            optionController.delegate = self
            
        case "directionSegue":
            let directionController = segue.destination as! DirectionViewController
            if ((locationManager.location?.coordinate) != nil){directionController.configureWith(currentLocationExist: true)}
            else{directionController.configureWith(currentLocationExist: false)}
            directionController.delegate = self
            
        case "allAtOnceSegue":
            let allAtOnceController = segue.destination as! AllAtOnceTableViewController
            assert(routeDirection != nil)
            allAtOnceController.configureWith(route: routeDirection!)
            
            
        default:
            assert(false, "Unhandled Segue")
        }
    }
    
    
    func direction(startName: String, startLat: Double, startLong: Double, endName: String, endLat: Double, endLong: Double) {
        var startlocation = CLLocationCoordinate2D()
        var endlocation = CLLocationCoordinate2D()
        
        if startName == "Current Location"{startlocation = locationManager.location!.coordinate}
        else{startlocation = CLLocation(latitude: startLat, longitude: startLong).coordinate}
        
        if endName == "Current Location"{endlocation = locationManager.location!.coordinate}
        else{endlocation = CLLocation(latitude: endLat, longitude: endLong).coordinate}
        
        let request = DirectionRequest(from: startlocation, to: endlocation)
        let directions = MKDirections(request: request)
        resetMapView(for: directions)
        
        directions.calculate { (response, error) in
            guard (error == nil) else {print(error!.localizedDescription); return}
            
            if let route = response?.routes.first {
                self.routeDirection = route
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                self.trashDirectionButton.isEnabled = true
                self.infoDirectionButton.isEnabled = true
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showDistance(distance: Double) -> String{
        let ft = distance * 3.28084
        return "\(Int(ft)) ft"
    }
    
    func oneAtATime(_ i : Int , route: MKRoute)
    {
        let steps = route.steps
        let step = steps[i]
        
        self.mapView.setVisibleMapRect(step.polyline.boundingMapRect, animated: true)
        
        let ETA = route.expectedTravelTime
        let dateform = Date(timeIntervalSinceNow: ETA)
        let ETAString = "Estimate Time Arrival : \(DateFormatter.localizedString(from: dateform, dateStyle: .short, timeStyle: .short))"
        
        let message = (i == 0 ? "Go straight for " + showDistance(distance: step.distance) : showDistance(distance: step.distance))
        
        let alertController = UIAlertController(title: i == 0 ? ETAString : step.instructions , message: message, preferredStyle: .actionSheet)
        
        
        let alertNext = UIAlertAction(title: "Next Step", style: .default) { (action) in
            self.oneAtATime(i+1, route: route)
        }
        
        let alertPrevious = UIAlertAction(title: "Previous Step", style: .default) { (action) in
            self.oneAtATime(i-1, route: route)
        }
        
        let alertStopShowing = UIAlertAction(title: i >= steps.count - 1 ? "Exit Directions" : "Stop Showing", style: .default) { (action) in
            
        }
        
        if i > 0 {alertController.addAction(alertPrevious)}
        if i < steps.count - 1 {alertController.addAction(alertNext)}
        alertController.addAction(alertStopShowing)
        
        
        if let presenter = alertController.popoverPresentationController {
            
            presenter.sourceView = view
            presenter.sourceRect = view.bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func infoDirectionAction(_ sender: Any) {
        let alertController = UIAlertController(title:"Step-by-Step Directions", message: "Choose the method to show the steps of direction", preferredStyle: .actionSheet)
        
        let actionOne = UIAlertAction(title: "One at a time", style: .default) { (action) in
            guard let route = self.routeDirection else{return}
            self.oneAtATime(0, route: route)
        }
        
        let actionAll = UIAlertAction(title: "All at once", style: .default) { (action) in
            self.performSegue(withIdentifier: "allAtOnceSegue", sender: sender)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(actionOne)
        alertController.addAction(actionAll)
        alertController.addAction(actionCancel)
        
        if let presenter = alertController.popoverPresentationController {
            
            presenter.sourceView = view
            presenter.sourceRect = view.bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func DirectionRequest(from startCoordinate: CLLocationCoordinate2D, to endCoordinate:CLLocationCoordinate2D) -> MKDirections.Request{
        let end = MKPlacemark(coordinate: endCoordinate)
        let start = MKPlacemark(coordinate: startCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: start)
        request.destination = MKMapItem(placemark: end)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    func resetMapView(for Newdirections: MKDirections){
        mapView.removeOverlays(mapView.overlays)
        directions.append(Newdirections)
        let _ = directions.map {$0.cancel()}
        directions.removeFirst()
    }
    
    @IBAction func trashDirection(_ sender: Any) {
        mapView.removeOverlays(mapView.overlays)
        let _ = directions.map {$0.cancel()}
        trashDirectionButton.isEnabled = false
        infoDirectionButton.isEnabled = false
    }
    
    
    func selectedBuilding(name: String, latitude: Double, longitude: Double) {
        self.dismiss(animated: true, completion: nil)
        DropPin(name: name, latitude: latitude, longitude: longitude)
    }
    
    func favoriteBuilding(name: String, latitude: Double, longitude: Double) {
        self.dismiss(animated: true, completion: nil)
        FavorPin(name: name, latitude: latitude, longitude: longitude)
    }
    
    func favoriteModeChanged(to: Bool) {
        favoritePin = to
        
        for annotation in mapView.annotations{
            for i in 0..<favoredBuildingsList.count{
                if (annotation.title == favoredBuildingsList[i].title){
                    self.mapView.removeAnnotation(annotation)
                }
            }
        }
        
        if to{
            for i in favoredBuildingsList{
                FavorPin(name: i.title!, latitude: i.coordinate.latitude, longitude: i.coordinate.longitude)
            }
        }
    }
    
//    func trackingModeChanged(to: Bool) {
//        locationTracking = to
//        mapView.showsUserLocation = to
//    }
    
    func mapChanged(to: Option){
        option = to
        switch option {
        case .standard :
            mapView.mapType = .standard
        case .satelite:
            mapView.mapType = .satellite
        case .hybrid:
            mapView.mapType = .hybrid
        }
    }
    
    func DropPin(name:String, latitude:Double, longitude:Double){
        addPin = true
        for i in 0..<self.favoredBuildingsList.count{
            if self.favoredBuildingsList[i].title != name{self.addPin = true}
            else{
                self.addPin = false
                
                break}
        }
        
        removeOneAnnoation(name: name)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if addPin{let pin = DroppedPin(title: name, coordinate: coordinate)
            mapView.addAnnotation(pin)
        }
        else{let pin = FavoredPin(title: name, coordinate: coordinate, show: true)
            if favoritePin{mapView.addAnnotation(pin)}
        }
        
        let span = MKCoordinateSpan(latitudeDelta: spanNumber/3, longitudeDelta: spanNumber/3)
        
        mapView.region = MKCoordinateRegion(center: coordinate, span: span)
    }
    
    func FavorPin(name:String, latitude:Double, longitude:Double){
        removeOneAnnoation(name: name)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let pin = FavoredPin(title: name, coordinate: coordinate, show: true)
        let span = MKCoordinateSpan(latitudeDelta: spanNumber/3, longitudeDelta: spanNumber/3)
        if favoritePin == true{
            mapView.addAnnotation(pin)
        }
        mapView.region = MKCoordinateRegion(center: coordinate, span: span)
    }
    
    func removeOneAnnoation(name:String){
        for annotation in mapView.annotations{
            if (annotation.title == name){
                self.mapView.removeAnnotation(annotation)
            }
        }
    }
}

