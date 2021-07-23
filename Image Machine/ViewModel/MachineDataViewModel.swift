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
    func deleteData(data: MachineData) {
        context.delete(data)
        
        do {
            try context.save()
            fetchCoreData()
        } catch {
            
        }
    }
}
