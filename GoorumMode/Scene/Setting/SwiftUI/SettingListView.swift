//
//  SettingListView.swift
//  GoorumMode
//
//  Created by 박소진 on 9/6/24.
//

import SwiftUI

struct SettingList: View {

    @ObservedObject var viewModel: SettingUIViewModel
    
    var item: SettingUI
    
    var body: some View {
        
        HStack {
            
            if let iconName = item.iconName {
                Image(uiImage: UIImage.templateImage(named: iconName) ?? UIImage())
                    .accessibilityHidden(true)
            }
            
            switch item.type {
                
            case .toggle(_):
                Toggle(
                    item.title.localized(),
                    isOn: $viewModel.isNotificationOn
                )
                .toggleStyle(BlackToggleStyle())
                
            case .detailText(let value, let showPopUp):
                CellTextView(title: item.title.localized())
//                    .accessibilityHint(item.title.accessibilityHint)
                Spacer()
                if showPopUp {
                    DatePicker("", selection: $viewModel.time, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: viewModel.time) { newValue in
                            if viewModel.isNotificationOn {
                                viewModel.scheduleNotification(at: newValue)
                            }
                        }
                } else {
                    Text(value)
                        .foregroundStyle(Color(uiColor: Constants.Color.Text.basicSubTitle))
                        .font(Font.init(
                            uiFont: Constants.Font.bold(size: showPopUp ? 16 : 13))
                        )
                }
                
            case .none(let isMail):
                if isMail {
                    CellTextView(title: item.title.localized())
//                        .accessibilityHint(item.title.accessibilityHint)
                        .onTapGesture {
                            viewModel.sendEmail()
                        }
                } else {
                    NavigationLink {
                        NavigationLazyView(InfoView(title: item.title.localized()))
                    } label: {
                        CellTextView(title: item.title.localized())
//                            .accessibilityHint(item.title.accessibilityHint)
                    }

                }
                
            }
            
        }
        .frame(height: 40)
        .padding(.leading, item.iconName == nil ? 6 : 0)
        .transition(.asymmetric(
            insertion: .move(edge: .leading),
            removal: .opacity))
        
    }
}
