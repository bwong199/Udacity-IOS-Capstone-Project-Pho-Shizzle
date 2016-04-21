//
//  DataFetch.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-12.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import CoreLocation

class DataFetch {
    var businesses: [Business]!
    
    func fetchZomatoData (latitude: Double, longitude: Double, page: Int, completionHandler:(success: Bool, error: String?, results: [Pho]) -> Void){
        
        let url = NSURL(string: "https://developers.zomato.com/api/v2.1/search?q=vietnamese&lat=\(latitude)&lon=\(longitude)&apikey=32cca5c64d799522c794ef24c5ebd21c&radius=20000&cuisines=vietnamese&start=\(page)")! ;
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data, response, error) -> Void in
            if let data = data {
                //                print(urlContent)
                
                do {
                    let jsonResult =  try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if jsonResult.count > 0 {
                        if let items = jsonResult["restaurants"] as? NSArray {
                            
                            
                            for item in items {
                                
                                if let restaurant = item["restaurant"] as? NSDictionary {
                                    
                                    
                                    //                                    down vote
                                    //                                    Is swift 2.0 is in the following way:
                                    //
                                    
                                    
                                    //                                    let userLocation:CLLocation = CLLocation(latitude: 11.11, longitude: 22.22)
                                    //                                    let phoLocation:CLLocation = CLLocation(latitude: 33.33, longitude: 44.44)
                                    //                                    let meters:CLLocationDistance = userLocation.distanceFromLocation(priceLocation)
                                    
                                    
                                    //                                    print()
                                    //                                    print(restaurant["user_rating"]!["aggregate_rating"]!!)
                                    //                                    print(restaurant["user_rating"]!["votes"]!!)
                                    
                                    
                                    //                                    for x in GlobalVariables.phoInfoList {
                                    //                                        if x.name != restaurant["name"]! as! String {
                                    
                        
                                    
                                    let newPho = Pho()
                                    
                                    let phoName = restaurant["name"]! as! String
                                    newPho.name = phoName
                                    newPho.rating = restaurant["user_rating"]!["aggregate_rating"] as! String
                                    
                                    
                                    newPho.votes = restaurant["user_rating"]!["votes"] as! String
                                    newPho.postalCode = restaurant["location"]!["zipcode"]!! as! String
                                    
                                    let phoAddress = restaurant["location"]!["address"]!! as! String
                                    newPho.address = phoAddress
                                    
                                    
                                    
                                    // Distance Calculation
                                    var phoLatitude = restaurant["location"]!["latitude"]!! as! String
                                    var phoLongitude = restaurant["location"]!["longitude"]!! as! String
                                    
                                    print("\(phoLatitude) \(phoLongitude)")
                                    
                                    var phoLatitudeD = Double(phoLatitude)
                                    var phoLongitudeD = Double(phoLongitude)
                                    
                                    let geocoder = CLGeocoder()
                                    if phoLatitude == "0.0000000000" && phoLongitude == "0.0000000000" {
                                        geocoder.geocodeAddressString(phoAddress, completionHandler: {(placemarks, error) -> Void in
                                            if((error) != nil){
                                                print("Error", error)
                                            }
                                            if let placemark = placemarks?.first {
                                                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                                                print("Geocoded \(coordinates.latitude) \(coordinates.longitude)")
                                                phoLatitudeD = coordinates.latitude
                                                phoLongitudeD = coordinates.longitude
                                                print("Geocoded \(phoLatitudeD) \(phoLongitudeD)")
                                                
                                                newPho.latitude = phoLatitudeD!
                                                newPho.longitude = phoLongitudeD!
                                            }
                                        })
                                    } else {
                                        newPho.latitude = phoLatitudeD!
                                        newPho.longitude = phoLongitudeD!
                                    }
                                    
                                    
                                    //                                    print("\(phoLatitudeD) \(phoLongitudeD)")
                                    
                                    
                                    let userLocation:CLLocation = CLLocation(latitude: GlobalVariables.userLatitude, longitude: GlobalVariables.userLongitude)
                                    let phoLocation:CLLocation = CLLocation(latitude: phoLatitudeD!, longitude: phoLongitudeD!)
                                    
                                    let phoDistance:CLLocationDistance = userLocation.distanceFromLocation(phoLocation)
                                    
                                    newPho.distanceFromUser = phoDistance / 1000
                                    
                                    //                                    print("Pho Distance \(phoDistance)")
                                    
                                    if !GlobalVariables.phoInfoList.contains(newPho){
                                        GlobalVariables.phoInfoList.append(newPho)
                                        
                                        GlobalVariables.phoInfoList.sortInPlace()
                                        
                                        DataFetch().fetchGoogleData(phoName, address: phoAddress ){(success, error, results) in
                                            if success {
                                                
                                            } else {
                                                
                                            }
                                            
                                        }
                                    }
                                    

                                    //                                        }
                                    //                                    }
                                    
                                    
                                    
                                    
                                    
                                    let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[0] as? ViewController
                                    
                                    
                                    //                                    viewController?.tableView.reloadData()
                                    //                                    print("\(restaurant["name"]!)   \(restaurant["user_rating"]!["aggregate_rating"]!!)  \(restaurant["user_rating"]!["votes"]!!)")
                                    //                                    print("\(restaurant["location"]!["latitude"]!!)  \(restaurant["location"]!["longitude"]!!)" )
                                }
                                
                                //                                print(restaurant)
                                
                            }
                        }
                    }
                    
                    completionHandler(success: true, error: nil, results: [])
                    
                    //                                        print(jsonResult)
                    
                } catch {
                    print("JSON Serialization failed")
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
        
        task.resume()
    }
    
    func fetchGoogleData(phoPlace: String, address: String, completionHandler:(success: Bool, error: String?, results: [Pho]) -> Void){
        //        print(phoPlace)
        //
        let urlParamter = phoPlace.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        if let phoPlace = phoPlace as? String {
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(GlobalVariables.userLatitude)%2C\(GlobalVariables.userLongitude)&radius=10000&type=restaurant&keyword=\(urlParamter)&key=AIzaSyAtq_jKJ6O-pM-wwvwpCx1n31yjwcI2cPI")!
            
            //            print(url)
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data, response, error) -> Void in
                if let data = data {
                    
                    do {
                        let jsonResult =  try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        
                        if jsonResult.count > 0 {
                            
                            //                                                        print(jsonResult)
                            
                            if let items = jsonResult["results"] as? NSArray {
                                
                                
                                if  let items = items as? NSArray {
                                    for item in items {
                                        
                                        if let name = item["name"] as? String, let rating = item["rating"] as? Double, let phoAddress = item["vicinity"] as? String {
                                            
                                            //                                            print("Google Rating \(name) \(rating)")
                                            
                                            for x in GlobalVariables.phoInfoList {
                                                
                                                //                                                print(x.address)
                                                //                                                print(phoAddress)
                                                
                                                if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(2)) == name.lowercaseString.substringToIndex(name.startIndex.advancedBy(2))
                                                    
                                                    //                                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(4)) == phoAddress.lowercaseString.substringToIndex(phoAddress.startIndex.advancedBy(4))
                                                {
                                                    x.gRating = rating
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        completionHandler(success: true, error: nil, results: [])
                        
                    } catch {
                        print("JSON Serialization failed")
                    }
                    
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertController = UIAlertController(title: nil, message:
                            "Failed to Download Data from Google Place", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        //                    self.presentViewController(alertController, animated: true, completion: nil)
                    })
                }
                
            }
            
            task.resume()
            
        }
        
        
    }
}