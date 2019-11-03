//
//  BuildingsTableViewController.swift
//  Campus Walk
//
//  Created by Chung, MINHO on 10/21/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit

protocol selectedDelegate : NSObject {
    func selectedBuilding(name:String, latitude:Double, longitude:Double)
}

class BuildingsTableViewController: UITableViewController {

    var buildingsModel = BuildingsModel.sharedInstance
    weak var delegate : selectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return buildingsModel.numberOfKeys
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buildingsModel.numberOfBuildingsinSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerButton = UIButton(frame: CGRect.zero)
        let title = buildingsModel.initials(index: section)
        headerButton.setTitle(title, for: .normal)
        headerButton.titleLabel?.textAlignment = .center
        headerButton.titleLabel?.font = UIFont(name: "Rockwell", size: 22)
        headerButton.setTitleColor(UIColor(red: 1.0, green: 234.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        headerButton.backgroundColor = UIColor(red: 137/255, green: 17/255, blue: 0, alpha: 1)
        
        
        //headerButton.addTarget(self, action: #selector(expandAndCollapse), for: .touchUpInside)
        //headerButton.tag = section
        
        return headerButton
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "findIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel!.text = buildingsModel.buildingName(indexPath: indexPath)
        cell.textLabel!.font = UIFont(name: "Rockwell", size: 20)

        return cell
    }

    override  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return buildingsModel.indexInitials
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameOfBuilding = buildingsModel.buildingName(indexPath: indexPath)
        let latitudeOfBuilding = buildingsModel.buildingLatitude(indexPath: indexPath)
        let longitudeOfBuilding = buildingsModel.buildingLongitude(indexPath: indexPath)
        delegate?.selectedBuilding(name: nameOfBuilding, latitude: latitudeOfBuilding, longitude: longitudeOfBuilding)
        
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
