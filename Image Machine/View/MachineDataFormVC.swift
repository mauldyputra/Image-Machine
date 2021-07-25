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
    
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var vm: MachineDataViewModel?
    var isEdit: Bool = false
    var data: MachineData?
    let layout = UICollectionViewFlowLayout()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let spacingBetweenCells: CGFloat = 11.0
    private let numberOfItemsPerRow:CGFloat = 2
    
    var idString = UUID().uuidString
    var nameString = ""
    var typeString = ""
    var qrString = ""
    var dateString = ""
    var images: [UIImage] = []
    
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
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if UIScreen.main.bounds.width <= 375 {
            layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 30)
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: (self.collectionView.frame.size.width/2)-15, height: (self.collectionView.frame.size.width/2)-15)
        } else {
            let totalSpacing = (2 * self.spacingBetweenCells) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
            let width = (self.collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow

            layout.itemSize = CGSize(width: width, height: width)
            layout.sectionInset = UIEdgeInsets(top: spacingBetweenCells, left: spacingBetweenCells, bottom: spacingBetweenCells, right: spacingBetweenCells)
            layout.minimumLineSpacing = spacingBetweenCells
            layout.minimumInteritemSpacing = spacingBetweenCells
        }
        self.collectionView?.collectionViewLayout = layout
        self.collectionView.allowsMultipleSelection = true

        self.collectionViewHeightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        self.view.layoutIfNeeded()
    }
    
    func setup() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style:.plain, target:nil, action:nil)
        
        idTextField.isEnabled = false
        dateTextField.datePicker(target: self, doneAction: #selector(done), cancelAction: #selector(cancel))
        dateTextField.setupRightImage(imageName: "arrowDown")
        selectBtn.layer.cornerRadius = 15
        saveBtn.layer.cornerRadius = 15
        
        if !isEdit {
            self.navigationItem.title = "Add Machine Data"
            self.idTextField.text = idString
        } else {
            self.navigationItem.title = "Edit Machine Data"
            self.idTextField.text = idString
            self.nameTextField.text = nameString
            self.typeTextField.text = typeString
            self.qrCodeTextField.text = self.qrString
            self.dateTextField.text = dateString
            dateTextField.datePicker(target: self, doneAction: #selector(done), cancelAction: #selector(cancel), value: dateString.toDate()!)
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
            print("User has denied the permission.")
        case .limited:
            print("User has denied the permission.")
        }
    }
    
    @available(iOS 13.0, *)
    func createData() {
        let newData = MachineData(context: context)
        
        newData.machineID = idTextField.text
        newData.machineName = nameTextField.text
        newData.machineType = typeTextField.text
        newData.machineQrCode = qrCodeTextField.text?.toInt64() ?? 0
        newData.maintenanceDate = dateTextField.text?.toDate()
        
        do {
            try context.save()
            self.vm?.fetchCoreData()
        } catch {
            //do nothing
        }
    }
    @available(iOS 13.0, *)
    func updateData() {
        self.data?.machineName = nameTextField.text
        self.data?.machineType = typeTextField.text
        self.data?.machineQrCode = qrCodeTextField.text?.toInt64() ?? 0
        self.data?.maintenanceDate = dateTextField.text?.toDate()
        
        do {
            try context.save()
            self.vm?.fetchCoreData()
        } catch {
            //do nothing
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func saveTapped(_ sender: UIButton) {
        if nameTextField.text!.isEmpty || typeTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Check Again", message: "Blank field must be filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            if !self.isEdit {
                self.createData()
            } else {
                self.updateData()
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}

@available(iOS 14, *)
extension MachineDataFormVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.collectionView.isHidden = false
                self.collectionViewContainer.isHidden = false
                self.collectionView.reloadData()
            }
        }
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.images.append(image)
                    }
                }
            }
        }
    }
}

extension MachineDataFormVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCellIdentifier", for: indexPath) as! photoCell
        
        cell.data = self.images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoViewVC()
        vc.image = self.images[indexPath.row]
        vc.index = indexPath.row + 1
        self.navigationController?.pushViewController(vc, animated: true)
        print("image indexPath.row: ", indexPath.row)
    }
    
}
