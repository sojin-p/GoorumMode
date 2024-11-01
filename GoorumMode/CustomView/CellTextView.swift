//
//  CellTextView.swift
//  GoorumMode
//
//  Created by 박소진 on 10/24/24.
//

import SwiftUI

struct CellTextView: View {
    
    var title: String

    var body: some View {
        Text(title)
            .font(Font.init(uiFont: Constants.Font.bold(size: 16)))
            .foregroundColor(Color(uiColor: Constants.Color.Text.basicTitle))
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .contentShape(Rectangle())
    }
    
}
