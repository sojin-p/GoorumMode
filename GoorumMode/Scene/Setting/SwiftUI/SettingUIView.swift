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
            ScrollView {
                VStack(alignment: .leading) { //접근성, 언어, 폰트변경
                    
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
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
                .animation(.easeInOut(duration: 0.15), value: viewModel.isNotificationOn)
                Spacer()
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .clipped()
        }
        
    }
}
