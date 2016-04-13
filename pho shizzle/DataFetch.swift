//
//  DataFetch.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-12.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit




class DataFetch {
    var businesses: [Business]!
    
    func fetchZomatoData (page: Int, completionHandler:(success: Bool, error: String?, results: [Pho]) -> Void){
        let url = NSURL(string: "https://developers.zomato.com/api/v2.1/search?q=vietnamese&lat=51.03&lon=-114.14&apikey=32cca5c64d799522c794ef24c5ebd21c&radius=10000&cuisines=vietnamese&start=\(page)")! ;
        
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
                                    //                                    let priceLocation:CLLocation = CLLocation(latitude: 33.33, longitude: 44.44)
                                    //                                    let meters:CLLocationDistance = userLocation.distanceFromLocation(priceLocation)
                                    
                                    
                                    //                                    print()
                                    //                                    print(restaurant["user_rating"]!["aggregate_rating"]!!)
                                    //                                    print(restaurant["user_rating"]!["votes"]!!)
                                    
                                    let newPho = Pho()
                                    
                                    let phoName = restaurant["name"]! as! String
                                    newPho.name = phoName
                                    newPho.rating = restaurant["user_rating"]!["aggregate_rating"] as! String
                                    
                                    
                                    newPho.votes = restaurant["user_rating"]!["votes"] as! String
                                    newPho.postalCode = restaurant["location"]!["zipcode"]!! as! String
                                    
                                    let phoAddress = restaurant["location"]!["address"]!! as! String
                                    newPho.address = phoAddress
                                    
                                    GlobalVariables.phoInfoList.append(newPho)
                                    GlobalVariables.phoInfoList.sort({ $0.rating > $1.rating })
                                    DataFetch().fetchGoogleData(phoName, address: phoAddress ){(success, error, results) in
                                        if success {
                                            
                                        } else {
                                            
                                        }
                                        
                                    }

                                    
                                    
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
                    
                    //                    print(jsonResult)
                    
                } catch {
                    print("JSON Serialization failed")
                }
                
            }
            
        }
        
        task.resume()
    }
    
    func fetchGoogleData(phoPlace: String, address: String, completionHandler:(success: Bool, error: String?, results: [Pho]) -> Void){
        print(phoPlace)
        
        let urlParamter = phoPlace.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        if let phoPlace = phoPlace as? String {
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=51.03%2C-114.14&radius=10000&type=restaurant&keyword=\(urlParamter)&key=AIzaSyAtq_jKJ6O-pM-wwvwpCx1n31yjwcI2cPI")!
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data, response, error) -> Void in
                if let data = data {
                    //                print(urlContent)
                    
                    do {
                        let jsonResult =  try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        
                        if jsonResult.count > 0 {
                            
                            if let items = jsonResult["results"] as? NSArray {
                                
                                
                                if  let items = items as? NSArray {
                                    for item in items {
                                        
                                        if let name = item["name"] as? String, let rating = item["rating"] as? Double, let phoAddress = item["vicinity"] as? String {
                                            
                                            //                                                    print("Google Rating \(name) \(rating)")
                                            
                                            for x in GlobalVariables.phoInfoList {
                                                
//                                                print(x.address)
//                                                print(phoAddress)
                                                
                                                if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(4)) == name.lowercaseString.substringToIndex(name.startIndex.advancedBy(4))
                                                    
                                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(4)) == phoAddress.lowercaseString.substringToIndex(phoAddress.startIndex.advancedBy(4))
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
                    
                    
                }
                
            }
            
            task.resume()
            
        }
        
        
    }
}