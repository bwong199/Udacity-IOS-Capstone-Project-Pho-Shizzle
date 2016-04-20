//
//  FavPhoViewController.swift
//  pho shizzle
//
//  Created by Ben Wong on 2016-04-15.
//  Copyright © 2016 Ben Wong. All rights reserved.
//


import UIKit
import CoreData

class FavPhoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    var list : [Pho] = []
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
  
    }
    
    override func viewWillDisappear(animated: Bool) {
        list.removeAll()
    }

    
    override func viewWillAppear(animated: Bool) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Restaurant")
        //        request.predicate = NSPredicate(format: "latitude = %@", latitude)
        
        
        request.returnsObjectsAsFaults = false
        
        
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                print(results)
                
                
                for result in results as! [NSManagedObject] {
             
                
                            var newPho = Pho()
                            newPho.name = result.valueForKey("name") as! String
                            newPho.address = result.valueForKey("address") as! String
                            newPho.phoneNumber = result.valueForKey("phone") as! String
                            newPho.latitude = result.valueForKey("latitude") as! Double
                            newPho.longitude = result.valueForKey("longitude") as! Double
                            
                            list.append(newPho)
                            
                            dispatch_async(dispatch_get_main_queue(),{
                                
                                self.tableView.reloadData()
                                
                            })
                        
                    
                    
                }
            }
        } catch {
        }
        

        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
        //                return 10
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        //        let cell = UITableViewCell()
        
        let pho = list[indexPath.row]
        
        cell.textLabel!.text = "\(pho.name) - \(pho.phoneNumber)"
        
        cell.detailTextLabel!.text = "\(pho.address)"
        
        return cell
    }
    
    
    
    
}