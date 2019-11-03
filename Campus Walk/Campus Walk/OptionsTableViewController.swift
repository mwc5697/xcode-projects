//
//  OptionsTableViewController.swift
//  Campus Walk
//
//  Created by Chung, MINHO on 10/22/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit
import MapKit

protocol optionDelegate : NSObject {
    func favoriteModeChanged(to: Bool)
    //func trackingModeChanged(to: Bool)
    func mapChanged(to: Option)
}

class OptionsTableViewController: UITableViewController {

    @IBOutlet weak var favoritePinSwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    
    weak var delegate : optionDelegate?
    //var locationTracking : Bool = false
    var favoritePin : Bool = false
    var locationManager : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoritePinSwitch.isOn = favoritePin
        //locationSwitch.isOn = locationTracking
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func configureWith(favoritePin : Bool, locationManager : CLLocationManager){
        self.favoritePin = favoritePin
        //self.locationTracking = locationTracking
        self.locationManager = locationManager
    }
    
    @IBAction func favoriteChangeAction(_ sender: UISwitch) {
        delegate?.favoriteModeChanged(to: sender.isOn)
    }
    
//    @IBAction func trackingChangeAction(_ sender: UISwitch) {
//        delegate?.trackingModeChanged(to: sender.isOn)
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if( indexPath.section==0)
        {
            if(indexPath.row == 0){delegate?.mapChanged(to: .standard)}
            else if(indexPath.row == 1){delegate?.mapChanged(to: .satelite)}
            else{delegate?.mapChanged(to: .hybrid)}
            
            if let navController = self.navigationController
            {
                navController.popViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
