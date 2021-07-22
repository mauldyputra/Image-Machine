//
//  MachineDataViewModel.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit
import CoreData

class MachineDataViewModel {
    
    var machineData = [MachineData]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @available(iOS 13.0, *)
    func fetchCoreData() {
        do {
            machineData = try context.fetch(MachineData.fetchRequest())
        } catch {
            
        }
    }
    
    @available(iOS 13.0, *)
    func saveToCoreData(id: String, name: String, type: String, qrCode: Int, maintenanceDate: Date) {
        let newData = MachineData(context: context)
        
        newData.machineID = id
        newData.machineName = name
        newData.machineType = type
        newData.machineQrCode = Int64(qrCode)
        newData.maintenanceDate = maintenanceDate
        
        do {
            try context.save()
            fetchCoreData()
        } catch {
            
        }
    }
    
    @available(iOS 13.0, *)
    func deleteData(data: MachineData) {
        context.delete(data)
        
        do {
            try context.save()
            fetchCoreData()
        } catch {
            
        }
    }
    
    @available(iOS 13.0, *)
    func updateData(data: MachineData, newName: String, newType: String, newQrCode: Int, newMaintenanceDate: Date) {
        
        data.machineName = newName
        data.machineType = newType
        data.machineQrCode = Int64(newQrCode)
        data.maintenanceDate = newMaintenanceDate
        
        do {
            try context.save()
            fetchCoreData()
        } catch {
            
        }
    }
}
