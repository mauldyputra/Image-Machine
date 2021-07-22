//
//  Date.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import Foundation

extension Date {
    
    func toString(format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "id")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
