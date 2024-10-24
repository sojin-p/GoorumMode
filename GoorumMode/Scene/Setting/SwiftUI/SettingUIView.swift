//
//  SettingUIView.swift
//  GoorumMode
//
//  Created by 박소진 on 9/2/24.
//

import SwiftUI

struct SettingUIView: View {
    
    @StateObject private var viewModel = SettingUIViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: Constants.Color.Background.basic)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) { //접근성
                        
                        ForEach(viewModel.settings, id: \.id) { section in
                            ForEach(section.items, id: \.id) { item in
                                SettingList(viewModel: viewModel, item: item)
                            }
                            
                            //섹션마다 구분선
                            if section.id != viewModel.settings.last?.id {
                                Divider()
                                    .padding(.vertical, 10)
                            }
                            
                        }
                    }
                    .font(Font.init(uiFont: Constants.Font.bold(size: 16)))
                    .foregroundStyle(Color(uiColor: Constants.Color.Text.basicTitle)) //폰트 색상
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 20)
                    .animation(.easeInOut(duration: 0.15), value: viewModel.isNotificationOn)
                    Spacer()
                }
                .navigationTitle("settingVC_Title".localized)
                .navigationBarTitleDisplayMode(.inline)
                .clipped()
            } //ZStack
            
        } //NavigationStack
        
    } //View
}
