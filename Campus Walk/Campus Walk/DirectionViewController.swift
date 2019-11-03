//
//  DirectionViewController.swift
//  Campus Walk
//
//  Created by Chung, MINHO on 10/28/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import UIKit

protocol directionDelegate : NSObject {
    func direction(startName:String, startLat:Double, startLong:Double, endName:String, endLat:Double, endLong:Double)
}

class DirectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var startingTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    
    var buildingsModel = BuildingsModel.sharedInstance
    weak var delegate : directionDelegate?
    
    var currentLocationExist = false
    var selectedNumberRow = 0
    
    var startName = ""
    var startLat = 0.0
    var startLong = 0.0
    var endName = ""
    var endLat = 0.0
    var endLong = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
              
        tableView.dataSource = self
        
        startingTextField.text = "Choose starting point..."
        destinationTextField.text = "Choose destination..."
        destinationTextField.backgroundColor = UIColor.gray
        
        
        if !currentLocationExist{currentLocationButton.isEnabled = false}
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func currentLocationButton(_ sender: Any) {
        if destinationTextField.backgroundColor == UIColor .gray{
            startingTextField.text = "Current Location"
            startingTextField.textColor = UIColor(displayP3Red: 136/255, green: 21/255, blue: 14/255, alpha: 1)
            startingTextField.backgroundColor = UIColor.gray
            destinationTextField.backgroundColor = UIColor(displayP3Red: 249/255, green: 247/255, blue: 233/255, alpha: 1)
            startName = "Current Location"
            selectedNumberRow += 1
            
        }
        else{
            destinationTextField.text = "Current Location"
            destinationTextField.backgroundColor = UIColor.gray
            destinationTextField.textColor = UIColor(displayP3Red: 136/255, green: 21/255, blue: 14/255, alpha: 1)
            
            endName = "Current Location"
            
            searchButton.isEnabled = true
            currentLocationButton.isEnabled = false
            tableView.allowsSelection = false
        }
        
    }
    
    @IBAction func deleteStartingButton(_ sender: Any) {
        startingTextField.text = "Choose starting point..."
        startingTextField.backgroundColor = UIColor(displayP3Red: 249/255, green: 247/255, blue: 233/255, alpha: 1)
        startingTextField.textColor = UIColor(displayP3Red: 192/255, green: 133/255, blue: 118/255, alpha: 1)
        destinationTextField.text = "Choose destination..."
        destinationTextField.backgroundColor = UIColor.gray
        destinationTextField.textColor = UIColor(displayP3Red: 192/255, green: 133/255, blue: 118/255, alpha: 1)
        
        startName = ""
        startLat = 0.0
        startLong = 0.0
        endName = ""
        endLat = 0.0
        endLong = 0.0
        
        searchButton.isEnabled = false
        if currentLocationExist{currentLocationButton.isEnabled = true}
        selectedNumberRow = 0
        tableView.allowsSelection = true
    }
    
    func configureWith(currentLocationExist : Bool){
        self.currentLocationExist = currentLocationExist
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return buildingsModel.numberOfKeys
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return buildingsModel.numberOfBuildingsinSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerButton = UIButton(frame: CGRect.zero)
        let title = buildingsModel.initials(index: section)
        headerButton.setTitle(title, for: .normal)
        headerButton.titleLabel?.textAlignment = .center
        headerButton.titleLabel?.font = UIFont(name: "Rockwell", size: 22)
        headerButton.setTitleColor(UIColor(red: 1.0, green: 234.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        headerButton.backgroundColor = UIColor(red: 137/255, green: 17/255, blue: 0, alpha: 1)
 
        return headerButton
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointIdentifier", for: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = buildingsModel.buildingName(indexPath: indexPath)
        cell.textLabel!.font = UIFont(name: "Helvetica", size: 20)
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return buildingsModel.indexInitials
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNumberRow += 1
        if selectedNumberRow == 2{tableView.allowsSelection = false}
        
        if destinationTextField.backgroundColor == UIColor .gray{
            startingTextField.text = buildingsModel.buildingName(indexPath: indexPath)
            startingTextField.backgroundColor = UIColor.gray
            startingTextField.textColor = UIColor(displayP3Red: 136/255, green: 21/255, blue: 14/255, alpha: 1)
            destinationTextField.backgroundColor = UIColor(displayP3Red: 249/255, green: 247/255, blue: 233/255, alpha: 1)
            
            startName = buildingsModel.buildingName(indexPath: indexPath)
            startLat = buildingsModel.buildingLatitude(indexPath: indexPath)
            startLong = buildingsModel.buildingLongitude(indexPath: indexPath)
            
        }
        else{
            destinationTextField.text = buildingsModel.buildingName(indexPath: indexPath)
            destinationTextField.backgroundColor = UIColor.gray
            destinationTextField.textColor = UIColor(displayP3Red: 136/255, green: 21/255, blue: 14/255, alpha: 1)
            
            endName = buildingsModel.buildingName(indexPath: indexPath)
            endLat = buildingsModel.buildingLatitude(indexPath: indexPath)
            endLong = buildingsModel.buildingLongitude(indexPath: indexPath)
            
            searchButton.isEnabled = true
            currentLocationButton.isEnabled = false
            
        }
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        delegate?.direction(startName: startName, startLat: startLat, startLong: startLong, endName: endName, endLat: endLat, endLong: endLong)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
