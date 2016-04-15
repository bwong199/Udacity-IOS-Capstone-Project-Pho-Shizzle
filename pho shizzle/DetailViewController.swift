//
//  DetailViewController.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-14.
//  Copyright © 2016 Ben Wong. All rights reserved.
//


import UIKit
import MapKit
import CoreData

class DetailViewController: UIViewController  {
    
    var pho : Pho? = nil
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var phoneLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var zomatoLabel: UILabel!
    
    @IBOutlet var googleLabel: UILabel!
    
    @IBOutlet var yelpLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        titleLabel.text = pho!.name
        phoneLabel.text = String(pho!.phoneNumber)
        addressLabel.text = pho!.address
        
        zomatoLabel.text = "\(pho!.rating) - \(pho!.votes) reviews"
        
        googleLabel.text = "\(pho!.gRating)"
        
        yelpLabel.text = "\(pho!.yRating) - \(pho!.yVotes) reviews"
        
        let latitudeAnn:CLLocationDegrees = pho!.latitude
        let longitudeAnn:CLLocationDegrees = pho!.longitude
        
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        self.mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)
        
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        //         now lets get the directory contents (including folders)

        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
            for x in directoryContents {
                print(x)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Restaurant")
        //        request.predicate = NSPredicate(format: "latitude = %@", latitude)
        let firstPredicate = NSPredicate(format: "name = %@", "\(pho!.name)")
        let secondPredicate = NSPredicate(format: "address = %@", "\(pho!.address)")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [firstPredicate, secondPredicate])
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                print(results)
                saveButton.hidden = true
                
                for result in results as! [NSManagedObject] {
                    
                    
                }
            }
        } catch {
        }
        
    }
    
    
    @IBAction func initDirection(sender: AnyObject) {
        
        
        let latitudeAnn:CLLocationDegrees = pho!.latitude
        let longitudeAnn:CLLocationDegrees = pho!.longitude
        
        let coordinates:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeAnn, longitudeAnn)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "\(pho!.name)"
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
        
        
    }
    
    @IBAction func savePho(sender: AnyObject) {
        
        saveButton.hidden = true
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newRestaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant", inManagedObjectContext: context)
        
        newRestaurant.setValue(pho!.latitude, forKey: "latitude")
        
        newRestaurant.setValue(pho!.longitude, forKey: "longitude")
        
        newRestaurant.setValue(pho!.name, forKey: "name")
        
        newRestaurant.setValue(pho!.phoneNumber, forKey: "phone")
        
        newRestaurant.setValue(pho!.address, forKey: "address")
        
        do {
            try context.save()
        } catch {
            print("There was a problem")
        }
    }
    
}