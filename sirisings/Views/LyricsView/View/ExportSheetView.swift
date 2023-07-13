//
//  ExportSheetView.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 13/4/23.
//

import SwiftUI

struct ExportSheetView: View {
    
    @EnvironmentObject var manager: LyricsManager
    @Environment(\.dismiss) var dismissView
    
    @Binding var isExporting: Bool
    @Binding var fileName: String
    
    var body: some View {
        VStack {
            NavbarView(leftAction: { dismissView() }, rightAction: {
                dismissView()
                isExporting.toggle()
            })
            Spacer()
            VStack {
                Text("Enter your File Name")
                    .font(.title.bold())
                HStack {
                    TextField("Enter Your File Name", text: $fileName)
                        .padding()
                        .background(cornerRadius: 12, fill: .init(white: 0.2))
                    Text(".json")
                        .padding()
                }
            }.padding()
            Spacer()
        }
    }
}
