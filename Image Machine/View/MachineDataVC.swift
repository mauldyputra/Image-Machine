//
//  MachineDataVC.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit

class MachineDataVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    private var selectedIndex = 0
    let picker = UIPickerView()
    let pickerData = ["Machine Name", "Machine Type"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        let addNewMachineData = AddMachineDataBtn(context: self)
        self.view.addSubview(addNewMachineData)
    }
    
    func setup() {
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(selectedIndex, inComponent: 0, animated: true)
        
        textField.inputView = picker
        textField.text = pickerData[selectedIndex]
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 0.5
        textField.setupRightImage(imageName: "arrowDown")
        
        hideKeyboardWhenTappedAround()
    }
}

extension MachineDataVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
        textField.text = pickerData[row]
        textField.resignFirstResponder()
    }
}
