//
//  DetailViewController.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-14.
//  Copyright © 2016 Ben Wong. All rights reserved.
//


import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var pho : Pho? = nil
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var phoneLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var zomatoLabel: UILabel!
    
    @IBOutlet var googleLabel: UILabel!
    
    @IBOutlet var yelpLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        titleLabel.text = pho!.name
        phoneLabel.text = String(pho!.phoneNumber)
        addressLabel.text = pho!.address
        
        zomatoLabel.text = "Zomato - \(pho!.rating) - \(pho!.votes)"
        
        googleLabel.text = "Google - \(pho?.gRating)"
        
        yelpLabel.text = "Yelp - \(pho!.yRating) - \(pho!.yVotes)"
        
        let latitudeAnn:CLLocationDegrees = pho!.latitude
        let longitudeAnn:CLLocationDegrees = pho!.longitude
        
        let latDelta:CLLocationDegrees = 0.1
        let lonDelta:CLLocationDegrees = 0.1
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        self.mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    @IBAction func initDirection(sender: AnyObject) {
        
        let latitudeAnn:CLLocationDegrees = pho!.latitude
        let longitudeAnn:CLLocationDegrees = pho!.longitude
        
        let coordinates:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
        
        var launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(pho!.name)"
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
        
        
    }
    
    
}