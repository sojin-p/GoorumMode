//
//  BlackToggleStyle.swift
//  GoorumMode
//
//  Created by 박소진 on 10/23/24.
//

import SwiftUI

struct BlackToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                //Toggle 배경 색
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? Color(uiColor: Constants.Color.Background.basicIcon) : Color(uiColor: Constants.Color.Background.basicSwitch)
                    )
                    .frame(width: 50, height: 30)
                
                Circle()
                    .fill(configuration.isOn ? Color(uiColor: Constants.Color.iconTint.basicWhite) : Color.white)
                    .frame(width: 26, height: 26)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}
