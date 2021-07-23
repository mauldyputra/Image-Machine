//
//  MachineDataFormVC.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit

class MachineDataFormVC: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var qrCodeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var vm: MachineDataViewModel?
    var isEdit: Bool?
    var data: MachineData?
    
    init(vm: MachineDataViewModel, data: MachineData, isEdit: Bool) {
        self.vm = vm
        self.data = data
        self.isEdit = isEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    init(vm: MachineDataViewModel, isEdit: Bool) {
        self.vm = vm
        self.isEdit = isEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style:.plain, target:nil, action:nil)
        saveBtn.layer.cornerRadius = 15
        idTextField.isEnabled = false
        dateTextField.datePicker(target: self, doneAction: #selector(done), cancelAction: #selector(cancel))
        dateTextField.setupRightImage(imageName: "arrowDown")
        
        if isEdit == false {
            self.navigationItem.title = "Add Machine Data"
            self.idTextField.text = UUID().uuidString
        } else {
            self.navigationItem.title = "Edit Machine Data"
            self.idTextField.text = self.data?.machineID ?? ""
            self.nameTextField.text = self.data?.machineName ?? ""
            self.typeTextField.text = self.data?.machineType ?? ""
            self.qrCodeTextField.text = self.data?.machineQrCode.toString()
            self.dateTextField.text = self.data?.maintenanceDate?.toString()
        }
    }
    
    @objc func cancel() {
        dateTextField.resignFirstResponder()
    }
    
    @objc func done() {
        if let datePickerView = self.dateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = datePickerView.date.toString()
            dateTextField.text = dateString
            
            dateTextField.resignFirstResponder()
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func saveTapped(_ sender: UIButton) {
        //error "Type of expression is ambigous without more context
//        if self.isEdit == false {
//            self.vm?.saveToCoreData(id: idTextField.text ?? "", name: nameTextField.text ?? "", type: typeTextField.text ?? "", qrCode: qrCodeTextField.text?.toInt64() ?? 0, maintenanceDate: dateTextField.text?.toDate() ?? Date())
//        } else {
//            self.vm?.updateData(data: self.data!, newName: nameTextField.text ?? "", newType: typeTextField.text ?? "", newQrCode: qrCodeTextField.text?.toInt64() ?? 0, newMaintenanceDate: dateTextField.text?.toDate() ?? Date())
//        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
