//
//  SetFoodViewController.swift
//  NutriMe Project
//
//  Created by Randy Noel on 01/12/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit
import CloudKit

protocol SaveData {
    func saveData(food: Food, eatCategory: EatCategory, portion: Float, date: Date)
    func dismissPage(dismiss: Bool)
}

class SetFoodViewController: UIViewController {
    
    var selectedSection: EatCategory?
    var selectedFood: UserFood?
    var totalPorsi: Float = 1.0
    
    var date = Date()
    var formatter = DateFormatter()
    var pickerCode: Int?
    var delegate : SaveData?
    
    let database = CKContainer.default().publicCloudDatabase
    let userID:String = UserDefaults.standard.value(forKey: "currentUserID") as! String
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtn(_ sender: Any) {
        
        let diaryRecord = CKRecord(recordType: "Diary")
        let selectedCategory = selectedSection.map{$0.rawValue}
        
        formatter.dateFormat = "EEEE, d MMM yyyy"
        
        diaryRecord.setValue(userID, forKey: "userID")
        diaryRecord.setValue(selectedFood?.ID, forKey: "foodID")
        diaryRecord.setValue(selectedFood?.name, forKey: "foodName")
        diaryRecord.setValue(selectedFood?.calories, forKey: "foodCalories")
        diaryRecord.setValue(selectedFood?.makros?.carbohydrate, forKey: "foodCarbohydrate")
        diaryRecord.setValue(selectedFood?.makros?.fat, forKey: "foodFat")
        diaryRecord.setValue(selectedFood?.makros?.protein, forKey: "foodProtein")
        diaryRecord.setValue(totalPorsi, forKey: "portion")
        diaryRecord.setValue(formatter.string(from: date), forKey: "date")
        diaryRecord.setValue(selectedCategory, forKey: "category")
        
        self.database.save(diaryRecord) { (record, error) in
            if error == nil {
                print(record!.recordID.recordName)
                //Dismiss View
                DispatchQueue.main.async {
                    self.delegate?.dismissPage(dismiss: true)
                    self.dismiss(animated: true)
//                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }
        }
    }
    
    @IBOutlet weak var detailTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.tableFooterView = UIView()
        
        detailTable.isScrollEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPicker"{
            let vc = segue.destination as! PickerViewController
            vc.delegate = self
            vc.pickerCode = self.pickerCode
            vc.selectedCategory = self.selectedSection
        }
    }
}

extension SetFoodViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 && indexPath.row <= 3{
            self.pickerCode = indexPath.row
            performSegue(withIdentifier: "toPicker", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as! SetFoodTableViewCell
        
        if indexPath.row == 0{
            cell.lblName.text = selectedFood?.name
            cell.lblDetail.text = ""
        }else if indexPath.row == 1{
            cell.lblName.text = "\(totalPorsi) Porsi"
            cell.lblDetail.text = "\(selectedFood!.calories * totalPorsi) Kkl"
            cell.accessoryType = .disclosureIndicator
        }else if indexPath.row == 2{
            cell.lblName.text = selectedSection.map { $0.rawValue }
            cell.lblDetail.text = ""
            cell.accessoryType = .disclosureIndicator
        }else{
            formatter.dateFormat = "EEEE, d MMM yyyy"
            cell.lblName.text = formatter.string(from: date)
            cell.lblDetail.text = ""
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
}

extension SetFoodViewController: DataTransfer{
    func getPortion(portion: Int) {
        self.totalPorsi = Float(portion)
        self.detailTable.reloadData()
    }
    
    func getDate(toDate: Date) {
        self.date = toDate
        self.detailTable.reloadData()
    }
    
    func getEatCategory(category: EatCategory) {
        self.selectedSection = category
        self.detailTable.reloadData()
    }
    
    
}
