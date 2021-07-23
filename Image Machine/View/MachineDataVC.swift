//
//  MachineDataVC.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class MachineDataVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    private var selectedIndex = 0
    let picker = UIPickerView()
    let pickerData = ["Machine Name", "Machine Type"]
    
    var vm = MachineDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        self.vm.fetchCoreData()
        self.tableView.reloadData()
    }
    
    func setup() {
        self.navigationItem.largeTitleDisplayMode = .always
        
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(selectedIndex, inComponent: 0, animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        setTextField()
        setTableView()
        hideKeyboardWhenTappedAround()
    }
    
    func setTextField() {
        textField.inputView = picker
        textField.text = pickerData[selectedIndex]
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 0.5
        textField.setupRightImage(imageName: "arrowDown")
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MachineDataCell", bundle: nil), forCellReuseIdentifier: "machineDataCellIdentifier")
    }
    
    @objc func didTapAdd() {
        let vc = MachineDataFormVC(vm: self.vm, isEdit: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 13.0, *)
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

@available(iOS 13.0, *)
extension MachineDataVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.machineData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "machineDataCellIdentifier", for: indexPath) as! MachineDataCell
        
        let data = self.vm.machineData[indexPath.row]
        
        if !self.vm.machineData.isEmpty {
            cell.machineName.text = data.value(forKey: "machineName") as? String
            cell.machineType.text = data.value(forKey: "machineType") as? String
            cell.position = indexPath.row
        } else {
            cell.machineName.text = "Machinedq"
            cell.machineType.text = "feqfoq"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = self.vm.machineData[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let vc = MachineDataFormVC(vm: self.vm, data: data, isEdit: true)
            
            vc.idString = data.machineID ?? ""
            vc.nameString = data.machineName ?? ""
            vc.typeString = data.machineType ??  ""
            vc.qrString = String(data.machineQrCode)
            vc.dateString = data.maintenanceDate?.toString() ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.vm.deleteData(data: data)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        
        present(sheet, animated: true)
    }
}
