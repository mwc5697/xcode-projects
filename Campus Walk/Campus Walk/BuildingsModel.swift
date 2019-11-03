//
//  BuildingsModel.swift
//  Campus Walk
//
//  Created by Chung, MINHO on 10/21/19.
//  Copyright © 2019 Chung, MINHO. All rights reserved.
//

import Foundation
import MapKit

struct BuildingsInfo : Codable{
    var name : String
    var opp_bldg_code : Int
    var year_constructed : Int
    var latitude : Double
    var longitude : Double
    var photo : String
}

typealias Solutions = [BuildingsInfo]

class BuildingsModel {
    
    static let sharedInstance = BuildingsModel()
    
    let initialCoordinate = CLLocationCoordinate2D(latitude: 40.794978, longitude: -77.860785)
    fileprivate let buildingSolutions : Solutions
    let buildingsByInitial : [String : [BuildingsInfo]]
    var buildingsKeys : [String] {return buildingsByInitial.keys.sorted()}
    
    fileprivate init(){
        
        let mainBundle = Bundle.main
        let solutionURL = mainBundle.url(forResource: "buildings", withExtension: "plist")
        var _buildingSolutions : Solutions
        var _buildingsByInitial = [String:[BuildingsInfo]]()
            
        do{
            let data = try Data(contentsOf: solutionURL!)
            let decoder = PropertyListDecoder()
            _buildingSolutions = try decoder.decode(Solutions.self, from: data)
        } catch {
            print(error)
            _buildingSolutions = []
        }
        
        buildingSolutions = _buildingSolutions.sorted{$0.name < $1.name}
        
        for building in buildingSolutions{
            let initial = String([Character](building.name)[0])
            if _buildingsByInitial[initial]?.append(building) == nil{
                _buildingsByInitial[initial] = [building]
            }
        }
        buildingsByInitial = _buildingsByInitial
        
        
    }
    
    var numberOfKeys : Int{return buildingsByInitial.keys.count}
    
    func numberOfBuildingsinSection(section:Int) -> Int {
        let initial = buildingsKeys[section]
        return buildingsByInitial[initial]!.count
    }
    
    func initials(index i:Int) -> String{
        let initial = buildingsKeys[i]
        return initial
    }
    
    var indexInitials : [String] {return buildingsByInitial.keys.sorted()}
    
    func buildingAtIndexPath(indexPath:IndexPath) -> BuildingsInfo{
        let initial = buildingsKeys[indexPath.section]
        return buildingsByInitial[initial]![indexPath.row]
    }
    
    var numberOfBuildings : Int{return buildingSolutions.count}
    
    func buildingName(indexPath:IndexPath) -> String{
        let building = buildingAtIndexPath(indexPath: indexPath)
        return building.name
    }
 
    func buildingCode(indexPath:IndexPath) -> Int{
        let building = buildingAtIndexPath(indexPath: indexPath)
        return building.opp_bldg_code
    }
    func buildingYear(indexPath:IndexPath) -> Int{
        let building = buildingAtIndexPath(indexPath: indexPath)
        return building.year_constructed
    }
    func buildingLatitude(indexPath:IndexPath) -> Double{
        let building = buildingAtIndexPath(indexPath: indexPath)
        return building.latitude
    }
    func buildingLongitude(indexPath:IndexPath) -> Double{
        let building = buildingAtIndexPath(indexPath: indexPath)
        return building.longitude
    }
    func buildingPhoto(indexPath:IndexPath) -> String{
        let building = buildingAtIndexPath(indexPath: indexPath)
        return building.photo
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
