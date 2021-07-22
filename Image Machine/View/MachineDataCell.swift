//
//  MachineDataCell.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit

class MachineDataCell: UITableViewCell {

    @IBOutlet weak var machineName: UILabel!
    @IBOutlet weak var machineType: UILabel!
    
    var vm: MachineDataViewModel?
    var position: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
