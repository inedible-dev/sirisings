//
//  Float+Extension.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
