//
//  ToastView.swift
//  GoorumMode
//
//  Created by 박소진 on 10/25/24.
//

import SwiftUI

struct ToastView: View {
    var message: String

    var body: some View {
        Text(message)
            .font(.init(uiFont: Constants.Font.bold(size: 15)))
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            .background(Color.white.opacity(0.7))
            .foregroundColor(.black)
            .cornerRadius(10)
    }
}
