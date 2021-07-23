//
//  String.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import Foundation

extension String {
    
    func toDate(format: String = "dd-MM-yyyy") -> Date? {
        if (self.isEmpty){
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "id")
        return dateFormatter.date(from: self)
    }
    
    func toInt64() -> Int64 {
        return Int64(self) ?? 0
    }
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
}
