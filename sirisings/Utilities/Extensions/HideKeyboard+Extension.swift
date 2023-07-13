//
//  HideKeyboard+Extension.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 12/4/23.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
