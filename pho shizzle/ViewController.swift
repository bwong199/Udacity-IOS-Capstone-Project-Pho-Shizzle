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
    
    var businesses: [Business]!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //
        DataFetch().fetchZomatoData(0){(success, error, results) in
            if success {
                for x in GlobalVariables.phoInfoList {
                    //                            print("\(x.name) \(x.rating) \(x.gRating)")
                    
                    Business.searchWithTerm(x.name, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                        self.businesses = businesses
                        
                        for business in businesses {
                            
                            
                            
                            for x in GlobalVariables.phoInfoList {
                                
                                print(x.name)
                                print(business.name)
                                print(x.address)
                                print(business.address!)
                                
                                                                if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(2)) == business.name!.lowercaseString.substringToIndex(business.name!.startIndex.advancedBy(2))
//                                
//                                                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(1)) == business.address!.lowercaseString.substringToIndex(business.address!.startIndex.advancedBy(1))
                                                                {
                                                                    print("\(business.name!) \(business.address!) \(business.rating!)")
                                                                    x.yRating = Double(business.rating!)
                                                                }
                            }
                            
                        }
                    })
                    
                    
                    self.tableView.reloadData()
                }
                
            } else {
                
            }
        }
        
        
        DataFetch().fetchZomatoData(21){(success, error, results) in
            if success {
                for x in GlobalVariables.phoInfoList {
                    //                            print("\(x.name) \(x.rating) \(x.gRating)")
                    
                    
                    Business.searchWithTerm(x.name, completion: { (businesses: [Business]!, error: NSError!) -> Void in
                        self.businesses = businesses
                        
                        for business in businesses {
                            
                            
                            
                            for x in GlobalVariables.phoInfoList {
                                
                                //                                                print(x.address)
                                //                                                print(phoAddress)
                                
                                if x.name.lowercaseString.substringToIndex(x.name.startIndex.advancedBy(4)) == business.name!.lowercaseString.substringToIndex(business.name!.startIndex.advancedBy(4))
                                    
//                                    &&  x.address.lowercaseString.substringToIndex(x.address.startIndex.advancedBy(1)) == business.address!.lowercaseString.substringToIndex(business.address!.startIndex.advancedBy(1))
                                {
                                    print("\(business.name!) \(business.address!) \(business.rating!)")
                                    x.yRating = Double(business.rating!)
                                }
                            }
                            
                        }
                    })
                    
                    
                    self.tableView.reloadData()
                }
                
            } else {
                
            }
        }
        
        
        
        //        Business.searchWithTerm("Vietnamese", completion: { (businesses: [Business]!, error: NSError!) -> Void in
        //            self.businesses = businesses
        //
        //            for business in businesses {
        //
        //                print("\(business.name!) \(business.address!) \(business.rating!)")
        //
        //            }
        //        })
        
        
        
        
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariables.phoInfoList.count
        //                return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        //        cell.textLabel!.text = product.title
        //                        cell.textLabel!.text = "Nike kicks"
        let pho = GlobalVariables.phoInfoList[indexPath.row]
        cell.textLabel!.text = "\(pho.name)  "
        cell.detailTextLabel!.text = "Zomato: \(pho.rating)    Google: \(pho.gRating)    Yelp: \(pho.yRating)"
        
        //
        //        cell.imageView!.image = UIImage(named: "darthvader@2x-iphone.png")
        //        cell.imageView!.image = UIImage(data: meme.image!)
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = GlobalVariables.phoInfoList[indexPath.row]
        
        //        self.performSegueWithIdentifier("showMemeSegue", sender: self)
    }
    
}

