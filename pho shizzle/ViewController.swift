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
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var selectedItem: Pho? = nil
    
    var list : [Pho] = []
    
    var businesses: [Business]!
    
    let basicCellIdentifier = "cell"
    
    @IBOutlet var adderssLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var manager:CLLocationManager!
     var refreshControl = UIRefreshControl()
    
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
        
        activityIndicator.startAnimating()
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController

    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Check if connected to the internet
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    
    func refreshTable(sender:AnyObject) {
        // Code to refresh table view
        
        GlobalVariables.phoInfoList.removeAll()
        
        
        self.tableView.reloadData()
        
        
        activityIndicator.startAnimating()
        
        manager.startUpdatingLocation()
        
        refreshControl.endRefreshing()
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
        //        manager.startMonitoringSignificantLocationChanges()
        
        DataFetch().fetchZomatoData(GlobalVariables.userLatitude, longitude: GlobalVariables.userLongitude, page: 0){(success, error, results) in
            if success {
                for x in GlobalVariables.phoInfoList {
                    
                    //                            print("\(x.name) \(x.rating) \(x.gRating)")
                    
                    Business.searchWithTerm(x.name, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                        self.businesses = businesses
                        
                        
                        if let businesses = businesses as? [Business] {
                            for business in businesses {
                                
                                //                                print(business.phoneNumber)
                                
                                for x in GlobalVariables.phoInfoList {
                                    
                                    if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(2)) == business.name!.lowercaseString.substringToIndex(business.name!.startIndex.advancedBy(2))
                                        //
                                        //                                                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(1)) == business.address!.lowercaseString.substringToIndex(business.address!.startIndex.advancedBy(1))
                                    {
                                        //                                    print("\(business.name!) \(business.address!) \(business.rating!)")
                                        if let phoneNumber = business.phoneNumber  {
                                            x.phoneNumber = phoneNumber
                                            
                                        }
                                        
                                        x.yRating = Double(business.rating!)
                                        x.yVotes = Int(business.reviewCount!)
                                        //                                        x.phoneNumber = business.phoneNumber!
                                    }
                                }
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                let alertController = UIAlertController(title: nil, message:
                                    "Failed to Download Data from Yelp", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                
                                //                    self.presentViewController(alertController, animated: true, completion: nil)
                            })
                        }
                        
                        self.activityIndicator.stopAnimating()
                    })
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.tableView.reloadData()
                        
                    })
                    
                    
                }
                
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: nil, message:
                        "Failed to Download Data from Zomato", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    //                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
        

        
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

