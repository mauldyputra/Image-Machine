//
//  MachineDataFormVC.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit
import PhotosUI

class MachineDataFormVC: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var qrCodeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var vm: MachineDataViewModel?
    var isEdit: Bool?
    var data: MachineData?
    var image: UIImage?
    
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
        selectBtn.layer.cornerRadius = 15
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
        
        self.collectionView.register(UINib(nibName: "photoCell", bundle: nil), forCellWithReuseIdentifier: "photoCellIdentifier")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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
    
    func showGallery() {
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 10
            DispatchQueue.main.async {
                let vc = PHPickerViewController(configuration: configuration)
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func selectTapped(_ sender: UIButton) {
        let photoAuth = PHPhotoLibrary.authorizationStatus()
        switch photoAuth {
        case .authorized:
            self.showGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    self.showGallery()
                }
            }
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        case .limited:
            // same same
            print("User has denied the permission.")
        }
    }
    
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

@available(iOS 14, *)
extension MachineDataFormVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        print("selected image: ", image)
                        self.collectionView.isHidden = false
                        self.image = image
                    }
                }
            }
        }
    }
}

extension MachineDataFormVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm?.machineData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCellIdentifier", for: indexPath) as! photoCell
        
        cell.data = self.image
        return cell
    }
    
}
