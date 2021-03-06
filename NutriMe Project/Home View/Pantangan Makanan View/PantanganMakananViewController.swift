//
//  PantanganMakananViewController.swift
//  NutriMe Project
//
//  Created by Leonnardo Benjamin Hutama on 13/01/20.
//  Copyright © 2020 whiteHat. All rights reserved.
//

import UIKit
import CloudKit

class PantanganMakananViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let allergies = ["Peanut", "Wheat", "Soy", "Egg", "Cow's Milk", "Fish", "Shrimp"]
    let restrictions = ["Vegetarian", "Gluten Free", "Halal"]
    var userRestrictions: [String] = []
    
    var userInfo : UserInfo?
    let database = CKContainer.default().publicCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRestrictions()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if isMovingFromParent{
            updateRecord()
        }
    }
    
    func getRestrictions() {
        let userID:String = UserDefaults.standard.value(forKey: "currentUserID") as! String
        
        let record = CKRecord.ID(recordName: userID)
        
        database.fetch(withRecordID: record) { (data, err) in
            if err != nil{
                print("No Data")
            }
            else{
                let name = data?.value(forKey: "name") as! String
                let gender = data?.value(forKey: "gender") as! String
                let dob = data?.value(forKey: "dob") as! String
                let weight = data?.value(forKey: "weight") as! Float
                let height = data?.value(forKey: "height") as! Float
                let caloriesGoal = data?.value(forKey: "caloriesGoal") as? Float
                let carbohydrateGoal = data?.value(forKey: "carbohydrateGoal") as? Float
                let fatGoal = data?.value(forKey: "fatGoal") as? Float
                let proteinGoal = data?.value(forKey: "proteinGoal") as? Float
                let mineralGoal = data?.value(forKey: "proteinGoal") as? Float
                let restrictions = data?.value(forKey: "restrictions") as? [String]
                print(restrictions)
                
                //                self.userInfo = UserInfo(userID: userID, name: name, dob: stringToDate(dob), gender: gender, height: height , weight: weight , currCalories: 0, caloriesNeed: caloriesGoal!, activities: nil, foodRestriction: nil, reminder: nil, caloriesGoal: caloriesGoal!, carbohydrateGoal: carbohydrateGoal, fatGoal: fatGoal, proteinGoal: proteinGoal, mineralGoal: mineralGoal)
                self.userInfo = UserInfo(userID: userID, name: name, dob: stringToDate(dob), gender: gender, height: height, weight: weight, currCalories: 0, currCarbo: 0, currProtein: 0, currFat: 0, currMineral: 0, activityCalories: 0, foodRestrictions: restrictions, caloriesGoal: caloriesGoal, carbohydrateGoal: carbohydrateGoal, fatGoal: fatGoal, proteinGoal: proteinGoal, mineralGoal: mineralGoal)
                
                print(self.userInfo)
                self.userRestrictions = self.userInfo!.foodRestrictions ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func updateRecord() {
        let recordID = CKRecord.ID(recordName: userInfo!.userID)
        
        database.fetch(withRecordID: recordID) { (record, error) in
            if error == nil {
                record?.setValue(self.userRestrictions ,forKey: "restrictions")
                
                self.database.save(record!) { (record, error) in
                    if error == nil {
                        print("Record Updated")
                    }
                    else{
                        print("Record not updated")
                    }
                    
                }
            }
            else{
                print("No data with id \(recordID)")
            }
            
        }
    }

}

extension PantanganMakananViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return restrictions.count
        }
        else {
            return allergies.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Restrictions"
        }
        else {
            return "Allergies"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestrictionCell", for: indexPath) as! PantanganMakananTableViewCell
        
        if indexPath.section == 0 {
            cell.textLbl.text = restrictions[indexPath.row]
            
            if userInfo?.foodRestrictions != nil {
                for restriction in userInfo!.foodRestrictions! {
                    if restriction == restrictions[indexPath.row] {
                        cell.accessoryType = .checkmark
                    }
                    else{
                        cell.selectionStyle = .none
                    }
                    
                    
                }
            }
        }
        else{
            cell.textLbl.text = allergies[indexPath.row]
            
            if userInfo?.foodRestrictions != nil {
                for restriction in userInfo!.foodRestrictions! {
                    if restriction == allergies[indexPath.row] {
                        cell.accessoryType = .checkmark
                    }
                    else{
                        cell.selectionStyle = .none
                    }
                    
                    
                }
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            if indexPath.section == 0 {
                for (i, restriction) in userRestrictions.enumerated() {
                    if restriction == restrictions[indexPath.row] {
                        userRestrictions.remove(at: i)
                    }
                }
            }
            else {
                for (i, restriction) in userRestrictions.enumerated() {
                    if restriction == allergies[indexPath.row] {
                        userRestrictions.remove(at: i)
                    }
                }
            }
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            if indexPath.section == 0 {
                userRestrictions.append(restrictions[indexPath.row])
            }
            else{
                userRestrictions.append(allergies[indexPath.row])
            }
        }
        print(userRestrictions)
        
    }
    
}
