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
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    let pickerData = ["Machine Name", "Machine Type"]
    
    var vm = MachineDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.vm.fetchCoreData()
        self.sort()
        self.tableView.reloadData()
    }
    
    func setup() {
        self.navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        configSegmentedControl()
        setTableView()
        hideKeyboardWhenTappedAround()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MachineDataCell", bundle: nil), forCellReuseIdentifier: "machineDataCellIdentifier")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func configSegmentedControl(){
        sortSegmentedControl.layer.borderColor = UIColor.white.cgColor
        sortSegmentedControl.layer.borderWidth = 1
    }
    
    func sort() {
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0:
            self.vm.machineData.sort(by: { $0.machineName ?? "" < $1.machineName ?? ""})
        case 1:
            self.vm.machineData.sort(by: { $0.machineType ?? "" < $1.machineType ?? ""})
        default:
            print("Out of index")
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sortSegmentedControlTapped(_ sender: UISegmentedControl) {
        self.sort()
    }
    
    @objc func didTapAdd() {
        let vc = MachineDataFormVC(vm: self.vm, isEdit: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 13.0, *)
extension MachineDataVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.vm.machineData.count != 0 {
            return self.vm.machineData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.vm.machineData.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "machineDataCellIdentifier", for: indexPath) as! MachineDataCell
            
            let data = self.vm.machineData[indexPath.row]
            
            cell.machineName.text = data.value(forKey: "machineName") as? String
            cell.machineType.text = data.value(forKey: "machineType") as? String
            cell.position = indexPath.row
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = "There are no data"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = self.vm.machineData[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit \(data.machineName!)", message: nil, preferredStyle: .actionSheet)
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
                self?.sort()
                self?.tableView.reloadData()
            }
        }))
        
        present(sheet, animated: true)
    }
}
