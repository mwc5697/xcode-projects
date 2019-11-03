//
//  FavoritesTableViewController.swift
//  Campus Walk
//
//  Created by Chung, MINHO on 10/21/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit

protocol favoriteDelegate : NSObject {
    func favoriteBuilding(name:String, latitude:Double, longitude:Double)
}

class FavoritesTableViewController: UITableViewController {

    var buildingsModel = BuildingsModel.sharedInstance
    weak var delegate : favoriteDelegate?
    
    var buildingList : [FavoredPin] = []
    var nameList : [String] = []
    var latitudeList : [Double] = []
    var longititudeList : [Double] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func configureWith(buildingList : [FavoredPin]){
        self.buildingList = buildingList
        for building in buildingList{
            
            nameList.append(building.title!)
            latitudeList.append(building.coordinate.latitude)
            longititudeList.append(building.coordinate.longitude)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buildingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorIdentifier", for: indexPath)
        // Configure the cell...
        cell.textLabel!.text = nameList[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Rockwell", size: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let nameOfBuilding = nameList[indexPath.row]
        let latitudeOfBuilding = latitudeList[indexPath.row]
        let longitudeOfBuilding = longititudeList[indexPath.row]
        delegate?.favoriteBuilding(name: nameOfBuilding, latitude: latitudeOfBuilding, longitude: longitudeOfBuilding)
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
