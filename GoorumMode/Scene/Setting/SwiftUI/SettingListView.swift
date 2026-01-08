//
//  SettingListView.swift
//  GoorumMode
//
//  Created by 박소진 on 9/6/24.
//

import SwiftUI

struct SettingList: View {

    @ObservedObject var viewModel: SettingUIViewModel
    
    var item: Setting
    
    var body: some View {
        
        HStack {
            
            if let iconName = item.iconName {
                iconView(iconName)
            }
            
            switch item.type {
                
            case .toggle(_):
                toggleView()
                
            case .detailText(let value, let showPopUp):
                detailTextView(value, showPopUp: showPopUp)
//                
//            case .none(let isMail):
//                noneView(isMail)
                
            case .action(let action):
                actionView(action)
            }
            
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint(item.title.accessibilityHint)
        .frame(height: 40)
        .padding(.leading, item.iconName == nil ? 6 : 0)
        .transition(.asymmetric(
            insertion: .move(edge: .leading),
            removal: .opacity))
        
    }
    
    private func iconView(_ iconName: String) -> some View {
        Image(uiImage: UIImage.templateImage(named: iconName) ?? UIImage())
    }
    
    private func toggleView() -> some View {
        Toggle(
            item.title.localized(),
            isOn: $viewModel.isNotificationOn
        )
        .toggleStyle(BlackToggleStyle())
    }
    
    private func detailTextView(_ value: String, showPopUp: Bool) -> some View {
        HStack {
            CellTextView(title: item.title.localized())
            Spacer()
            
            if showPopUp {
                DatePicker("", selection: $viewModel.time, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .onChange(of: viewModel.time) { newValue in
                        if viewModel.isNotificationOn {
                            viewModel.scheduleNotification(at: newValue)
                            viewModel.showingPopup = true
                        }
                    }
            } else {
                Text(value)
                    .foregroundStyle(Color(uiColor: Constants.Color.Text.basicSubTitle))
                    .font(Font(uiFont: Constants.Font.bold(size: 13)))
            }
        }
    }
    
    private func noneView(_ isMail: Bool) -> some View {
        if isMail {
            return AnyView(
                CellTextView(title: item.title.localized())
                    .onTapGesture {
                        viewModel.sendEmail()
                    }
            )
        } else {
            return AnyView(
                NavigationLink(destination: NavigationLazyView(InfoView(title: item.title.localized()))) {
                    CellTextView(title: item.title.localized())
                }
            )
        }
    }
    
    @ViewBuilder
    private func actionView(_ action: SettingAction) -> some View {
        switch action {
        case .email:
            CellTextView(title: item.title.localized())
                .onTapGesture { viewModel.sendEmail() }
        case .diaryExport:
            NavigationLink(destination: NavigationLazyView(DiaryExportView(title: item.title.localized()))) {
                CellTextView(title: item.title.localized())
            }
        case .info:
            NavigationLink(destination: NavigationLazyView(InfoView(title: item.title.localized()))) {
                CellTextView(title: item.title.localized())
            }
        case .version:
            CellTextView(title: item.title.localized())
        }
    }

    
}
