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
                Image(iconName)
            }
            
            switch item.type {
                
            case .toggle(_):
                Toggle(item.title.rawValue, isOn: $viewModel.isNotificationOn)
                    .tint(.black) //색 변경
                
            case .detailText(let value):
                Text(item.title.rawValue)
                Spacer()
                Text(value)
                    .foregroundStyle(.gray) //색 변경, 터치시 팝업창
                //버전 디테일 크기 or 색 조정
                
            case .none:
                Text(item.title.rawValue)
                //정보 클릭시 다음페이지 (개인정보 정책, 오픈소스 등)
                //문의 클릭시 이메일 연결
            }
            
        }
        .frame(height: 40)
        .padding(.leading, item.iconName == nil ? 6 : 0)
        .transition(.asymmetric(
            insertion: .move(edge: .leading),
            removal: .opacity))
        
    }
}
