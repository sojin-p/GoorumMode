//
//  InfoView.swift
//  GoorumMode
//
//  Created by 박소진 on 10/23/24.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var title: String
    
    var body: some View {
        ZStack {
            Color(uiColor: Constants.Color.Background.basic)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("setting_PrivacyPolicy".localized)
                        Spacer()
                    }
                    .frame(height: 40)
                    .onTapGesture {
                        openURL("https://goorumode.notion.site/3c6efe5be9ac4707b29689852505caf0?pvs=4")
                    }
                }
                .font(Font.init(uiFont: Constants.Font.bold(size: 16)))
                .foregroundStyle(Color(uiColor: Constants.Color.Text.basicTitle))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 20)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(uiColor: Constants.Color.iconTint.basicBlack))
                    }
                }
            }
            .clipped()
        }
        
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
