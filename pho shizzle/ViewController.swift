//
//  ViewController.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-11.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var selectedItem: Pho? = nil
    
    var list : [Pho] = []
    
    var businesses: [Business]!
    
    let basicCellIdentifier = "cell"
    
    @IBOutlet var adderssLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get own location
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print(locations)
        //
        //
        //        print("Found user's location: \(locations)")
        
        let userLocation:CLLocation = locations[0]
        
        // Set user's latitude and longitude so it's available throughout the app
        GlobalVariables.userLatitude = userLocation.coordinate.latitude
        GlobalVariables.userLongitude = userLocation.coordinate.longitude
        
        //        print("\(GlobalVariables.userLatitude) \(GlobalVariables.userLongitude)")
        
        // Put location to where user is
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:  { (placemarks, error) -> Void in
            if(error != nil){
                print(error)
            } else {
                if placemarks!.count > 0{
                    
                    let p = (placemarks![0])
                    
                    //                    print(p)
                    
                    if let subThoroughfare = p.subThoroughfare ,
                        let thoroughfare = p.thoroughfare ,
                        let locality = p.locality ,
                        let country = p.country,
                        let postalCode = p.postalCode
                    {
                        self.adderssLabel.text = "\(subThoroughfare) \(thoroughfare) \n \(locality) \(country) \n \(postalCode) "
                    }
                    
                    
                    
                }
            }
        })
        
        manager.stopUpdatingLocation()
        manager.startMonitoringSignificantLocationChanges()
        
        DataFetch().fetchZomatoData(GlobalVariables.userLatitude, longitude: GlobalVariables.userLongitude, page: 0){(success, error, results) in
            if success {
                for x in GlobalVariables.phoInfoList {
                    //                            print("\(x.name) \(x.rating) \(x.gRating)")
                    
                    Business.searchWithTerm(x.name, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                        self.businesses = businesses
                        
                        
                        if let businesses = businesses as? [Business] {
                            for business in businesses {
                                
                                for x in GlobalVariables.phoInfoList {
                                    
                                    if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(2)) == business.name!.lowercaseString.substringToIndex(business.name!.startIndex.advancedBy(2))
                                        //
                                        //                                                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(1)) == business.address!.lowercaseString.substringToIndex(business.address!.startIndex.advancedBy(1))
                                    {
                                        //                                    print("\(business.name!) \(business.address!) \(business.rating!)")
                                        x.yRating = Double(business.rating!)
                                        x.yVotes = Int(business.reviewCount!)
                                        
//                                        x.phoneNumber = business.phoneNumber!
                                        
                                        
                                        
                                    }
                                }
                            }
                        }
                    })
                    self.tableView.reloadData()
                }
                
            } else {
                
            }
        }
        
//        DataFetch().fetchZomatoData(GlobalVariables.userLatitude, longitude: GlobalVariables.userLongitude, page: 21){(success, error, results) in
//            if success {
//                for x in GlobalVariables.phoInfoList {
//                    //                            print("\(x.name) \(x.rating) \(x.gRating)")
//                    
//                    Business.searchWithTerm(x.name, completion: { (businesses: [Business]!, error: NSError!) -> Void in
//                        self.businesses = businesses
//                        
//                        
//                        if let businesses = businesses as? [Business] {
//                            for business in businesses {
//                                
//                                for x in GlobalVariables.phoInfoList {
//                                    
//                                    if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(2)) == business.name!.lowercaseString.substringToIndex(business.name!.startIndex.advancedBy(2))
//                                        //
//                                        //                                                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(1)) == business.address!.lowercaseString.substringToIndex(business.address!.startIndex.advancedBy(1))
//                                    {
//                                        //                                    print("\(business.name!) \(business.address!) \(business.rating!)")
//                                        x.yRating = Double(business.rating!)
//                                        x.yVotes = Int(business.reviewCount!)
////                                        x.phoneNumber = business.phoneNumber!
//                                        
//                                    }
//                                }
//                            }
//                        }
//                    })
//                    
//                    self.tableView.reloadData()
//                }
//                
//            } else {
//                
//            }
//        }
//        
//        DataFetch().fetchZomatoData(GlobalVariables.userLatitude, longitude: GlobalVariables.userLongitude, page: 41){(success, error, results) in
//            if success {
//                for x in GlobalVariables.phoInfoList {
//                    //                            print("\(x.name) \(x.rating) \(x.gRating)")
//                    
//                    Business.searchWithTerm(x.name, completion: { (businesses: [Business]!, error: NSError!) -> Void in
//                        self.businesses = businesses
//                        
//                        
//                        if let businesses = businesses as? [Business] {
//                            for business in businesses {
//                                
//                                for x in GlobalVariables.phoInfoList {
//                                    
//                                    if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(2)) == business.name!.lowercaseString.substringToIndex(business.name!.startIndex.advancedBy(2))
//                                        //
//                                        //                                                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(1)) == business.address!.lowercaseString.substringToIndex(business.address!.startIndex.advancedBy(1))
//                                    {
//                                        //                                    print("\(business.name!) \(business.address!) \(business.rating!)")
//                                        x.yRating = Double(business.rating!)
//                                        x.yVotes = Int(business.reviewCount!)
////                                        x.phoneNumber = business.phoneNumber!
//                                        
//                                    }
//                                }
//                            }
//                        }
//                    })
//                    
//                    self.tableView.reloadData()
//                }
//                
//            } else {
//                
//            }
//        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariables.phoInfoList.count
        //                return 10
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! CustomTableViewCell
        //        cell.textLabel!.text = product.title
        //                        cell.textLabel!.text = "Nike kicks"
        let pho = GlobalVariables.phoInfoList[indexPath.row]
        
        cell.title.text = "\(pho.name) "
        cell.subtitle.text = "Zomato: \(pho.rating)    Google: \(pho.gRating)    Yelp: \(pho.yRating)"
        
        
        if Int(pho.distanceFromUser) > 100 {
            cell.distance.text = "Unknown"
        } else {
            cell.distance.text = "\(String(format: "%.1f", pho.distanceFromUser)) km"
        }
        
        if Double(pho.rating) >= 4.00 {
            cell.backgroundColor = UIColor.greenColor()
        } else if Double(pho.rating) <= 3.00 {
            cell.backgroundColor = UIColor.redColor()
            cell.title.textColor = UIColor.whiteColor()
            cell.subtitle.textColor = UIColor.whiteColor()
            cell.distance.textColor = UIColor.whiteColor()
        }
        else {
            cell.backgroundColor = UIColor.clearColor()
            cell.title.textColor = UIColor.blackColor()
            cell.subtitle.textColor = UIColor.blackColor()
            cell.distance.textColor = UIColor.blackColor()
        }
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = GlobalVariables.phoInfoList[indexPath.row]
        
        self.performSegueWithIdentifier("detailViewSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detailViewSegue"{
            let detailVC = segue.destinationViewController as! DetailViewController
            
            detailVC.pho = self.selectedItem
        }
        
        
        
    }
}

