//
//  SetFoodViewController.swift
//  NutriMe Project
//
//  Created by Randy Noel on 01/12/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit

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
  
  @IBAction func cancelBtn(_ sender: Any) {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  @IBAction func saveBtn(_ sender: Any) {
//    delegate?.saveData(food: selectedFood!, eatCategory: selectedSection!, portion: totalPorsi, date: date)
    delegate?.dismissPage(dismiss: true)
    self.dismiss(animated: true)
  }
  
  @IBOutlet weak var detailTable: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()
    
    print(selectedSection)
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
