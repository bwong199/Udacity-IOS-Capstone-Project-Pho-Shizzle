//
//  ViewController.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-11.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedItem: Pho? = nil
    
    var list : [Pho] = []
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let url = NSURL(string: "https://developers.zomato.com/api/v2.1/search?q=pho&lat=51.03&lon=-114.14&apikey=32cca5c64d799522c794ef24c5ebd21c&radius=5000&cuisines=vietnamese")! ;
        
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
                                    
                                    newPho.name = restaurant["name"]! as! String
                                    newPho.rating = restaurant["user_rating"]!["aggregate_rating"] as! String
                                    
                                    
                                    newPho.votes = restaurant["user_rating"]!["votes"] as! String
                                    newPho.postalCode = restaurant["location"]!["zipcode"]!! as! String
                                    newPho.address = restaurant["location"]!["address"]!! as! String
                                    
                                    
                                    self.list.append(newPho)
                                    self.tableView.reloadData()
                                    
                                    //                                    print("\(restaurant["name"]!)   \(restaurant["user_rating"]!["aggregate_rating"]!!)  \(restaurant["user_rating"]!["votes"]!!)")
                                    //                                    print("\(restaurant["location"]!["latitude"]!!)  \(restaurant["location"]!["longitude"]!!)" )
                                }
                                
                                //                                print(restaurant)
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    //                    print(jsonResult)
                    
                } catch {
                    print("JSON Serialization failed")
                }
                
                
            }
            
        }
        
        task.resume()
        self.tableView.reloadData()
        
        //        for x in self.list {
        //            print(x.name)
        //        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
        //                return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        //        cell.textLabel!.text = product.title
        //                        cell.textLabel!.text = "Nike kicks"
        let pho = self.list[indexPath.row]
        cell.textLabel!.text = "\(pho.name) \(pho.rating) \(pho.votes) "
        cell.detailTextLabel!.text = "\(pho.address)"
    
        //
        //        cell.imageView!.image = UIImage(named: "darthvader@2x-iphone.png")
        //        cell.imageView!.image = UIImage(data: meme.image!)
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = self.list[indexPath.row]
        
        //        self.performSegueWithIdentifier("showMemeSegue", sender: self)
    }
    
}

