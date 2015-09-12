//
//  ItemTableViewController.swift
//  scan4PASE
//
//  Created by Dhruv Sringari on 3/16/15.
//  Copyright (c) 2015 Sringari Worldwide. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate,UINavigationControllerDelegate {
    
    var filteredProducts : NSArray = NSArray()
    var filteredCustomProducts : NSArray = NSArray()
    var customProducts : NSArray = NSArray()
    var products : NSMutableArray = NSMutableArray()
    var selectedProduct : NSDictionary?
    var edit : Bool = false
    var showCustom : Bool = false
    var first = true
    
    
    // Load Existing Products into Array
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 118 // strange constraint problems w/o this
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        products = NSMutableArray(array: ITData.getAllProducts())
        
        let pred = NSPredicate(format: "custom == true")
        customProducts = products.filteredArrayUsingPredicate(pred)
        products.removeObjectsInArray(customProducts as [AnyObject])
        tableView.reloadData()
    }
    
    @IBAction func addObject(sender: AnyObject) {
        edit = false
        performSegueWithIdentifier("edit", sender: self)
    }
    
    
    func filterContentForSearchText(searchText: String) {
        let resultPredicate = NSPredicate(format: "name Contains[cd] %@ OR sku Contains[cd] %@", searchText,searchText)
        filteredProducts = products.filteredArrayUsingPredicate(resultPredicate)
        
        filteredCustomProducts = customProducts.filteredArrayUsingPredicate(resultPredicate);
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, didLoadSearchResultsTableView tableView: UITableView) {
        tableView.rowHeight = 118 // strange constraint problems w/o this
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "edit") {
            
            if (edit) {
                
                if let vc = segue.destinationViewController as? EditItemViewController {
                    vc.product = selectedProduct!
                    vc.edit = true
                }
                
            } else {
                
                if let vc = segue.destinationViewController as? EditItemViewController {
                    vc.edit = false
                }
                
            }
            
            
        }
        
    }
    
    
    
}

// TableView Delegate Methods
extension ItemTableViewController {
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 2
    }
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var name: String
        switch(section) {
        case 0:
            name = "Custom Items"
            break
        case 1:
            name = "Standard Items"
            break
        default:
            name = ""
            break
        }
        return name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if (section == 1) {
            if tableView == self.searchDisplayController!.searchResultsTableView {
                return self.filteredProducts.count
            } else {
                return products.count;
            }
        } else {
            if tableView == self.searchDisplayController!.searchResultsTableView {
                return filteredCustomProducts.count
            } else {
                return customProducts.count;
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        edit = true
        
        var p : NSArray
        
        if (indexPath.section == 0) {
            if (tableView == self.searchDisplayController!.searchResultsTableView) {
                p = filteredCustomProducts;
                showCustom = true
            } else {
                p = customProducts;
                showCustom = true
            }
        } else {
            if (tableView == self.searchDisplayController!.searchResultsTableView) {
                p = filteredProducts;
                showCustom = false
            } else {
                p = products;
                showCustom = false
            }
        }
        
        selectedProduct = p[indexPath.row] as? NSDictionary
        performSegueWithIdentifier("edit", sender: self)
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as!ItemTableViewCell
        
        
        // Configure the cell...
        // Get Values for ibo and retail as decimal because its more accurate
        
        // Should the cells be Custom Or Regular based on section
        var p : NSArray
        if (indexPath.section == 0) {
            if (tableView == self.searchDisplayController!.searchResultsTableView) {
                p = filteredCustomProducts;
            } else {
                p = customProducts;
            }
            
            
        } else {
            if (tableView == self.searchDisplayController!.searchResultsTableView) {
                p = filteredProducts;
            } else {
                p = products;
            }
        }
        
        
        
        let iboCostNumber : NSDecimalNumber = p.objectAtIndex(indexPath.row).objectForKey("iboCost") as! NSDecimalNumber
        let retailCostNumber : NSDecimalNumber = p.objectAtIndex(indexPath.row).objectForKey("retailCost") as! NSDecimalNumber
        
        cell.skuLabel!.text = p.objectAtIndex(indexPath.row).objectForKey("sku") as? String
        cell.nameLabel!.text = p.objectAtIndex(indexPath.row).objectForKey("name") as? String
        cell.iboCostLabel!.text = iboCostNumber.stringValue
        cell.retailCostLabel!.text = retailCostNumber.stringValue
        
        if (p.objectAtIndex(indexPath.row).objectForKey("custom") as! Bool == true) {
            cell.backgroundColor = UIColor(red: 0.141, green: 0.929, blue: 0.878, alpha: 0.5)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
}




