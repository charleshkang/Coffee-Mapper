//
//  CMHomeViewController.swift
//  Coffee Mapper
//
//  Created by Charles Kang on 4/13/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import MapKit
import UIKit
import RealmSwift

class HomeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    // IBOutlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    
    // Properties
    let distanceSpan: Double = 1000
    var locationManager: CLLocationManager?
    var lastLocation:CLLocation?
    var venues:[Venue]?
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.onVenuesUpdated(_:)), name: API.notifications.venuesUpdated, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let mapView = self.mapView {
            mapView.delegate = self
        }
        if let tableView = self.tableView {
            tableView.delegate = self
            tableView.dataSource = self
        }
        navigationController?.navigationBar.hidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            locationManager!.startUpdatingLocation()
        }
    }
    
    func onVenuesUpdated(notification: NSNotification) {
        refreshVenues(nil)
    }
    
    func locationManager(manager: CLLocationManager,
                         didUpdateToLocation newLocation: CLLocation,
                                             fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            let annotationView = MKPinAnnotationView()
            annotationView.pinTintColor = UIColor.blueColor()
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)
            mapView.setRegion(region, animated: true)
            refreshVenues(newLocation, getDataFromFoursquare: true)
        }
    }
    
    func refreshVenues(location: CLLocation?, getDataFromFoursquare:Bool = false) {
        if location != nil {
            lastLocation = location
        }
    
        if let location = lastLocation {
            if getDataFromFoursquare == true {
                FoursquareAPI.sharedInstance.getCoffeeShopsWithLocation(location)
            }
            
            let (start, stop) = calculateCoordinatesWithRegion(location)
            let predicate = NSPredicate(format: "latitude < %f AND latitude > %f AND longitude > %f AND longitude < %f", start.latitude, stop.latitude, start.longitude, stop.longitude)
            let realm = try! Realm()
            
            venues = realm.objects(Venue).filter(predicate).sort {
                location.distanceFromLocation($0.coordinate) < location.distanceFromLocation($1.coordinate)
            }
            
            for venue in venues! {
                let annotation = CoffeeAnnotation(title: venue.name, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
                mapView?.addAnnotation(annotation)
            }
            tableView?.reloadData()
        }
    }
    
    func calculateCoordinatesWithRegion(location:CLLocation) -> (CLLocationCoordinate2D, CLLocationCoordinate2D)
    {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distanceSpan, distanceSpan)
        
        var start:CLLocationCoordinate2D = CLLocationCoordinate2D()
        var stop:CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        start.latitude  = region.center.latitude  + (region.span.latitudeDelta  / 2.0)
        start.longitude = region.center.longitude - (region.span.longitudeDelta / 2.0)
        stop.latitude   = region.center.latitude  - (region.span.latitudeDelta  / 2.0)
        stop.longitude  = region.center.longitude + (region.span.longitudeDelta / 2.0)
        
        return (start, stop)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.isKindOfClass(MKAnnotation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
        }
        view?.canShowCallout = true
        
        
        return view
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject)
    {
        DataService.dataService.USER_REF.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        print("logged out: \(NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid"))")
        
        let loginVC = self.storyboard!.instantiateViewControllerWithIdentifier("loginIdentifier") as! LoginViewController
        presentViewController(loginVC, animated: true, completion: nil)
    }
    
    // MARK: Table View Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return venues?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier")
        }
        if let venue = venues?[indexPath.row] {
            cell!.textLabel?.text = venue.name
            cell!.detailTextLabel?.text = venue.address
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let venue = venues?[indexPath.row] {
            let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)), distanceSpan, distanceSpan)
            mapView?.setRegion(region, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        guard let indexPath = tableView?.indexPathForSelectedRow,
            venue = venues?[indexPath.row],
            detailVC = segue.destinationViewController as? DetailViewController else {
                return
        }
        detailVC.venue = venue
    }
}
