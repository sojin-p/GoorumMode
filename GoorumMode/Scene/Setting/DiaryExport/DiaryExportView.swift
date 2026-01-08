//
//  DiaryExportView.swift
//  GoorumMode
//
//  Created by 박소진 on 12/30/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct DiaryExportView: View {
    
    @StateObject private var viewModel = DiaryExportViewModel()
    @State private var showExporter = false
    
    var title: String
    
    var body: some View {
        ZStack {
            Color(uiColor: Constants.Color.Background.basic)
                .ignoresSafeArea(.all)
            
            ZStack {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("모든 일기를 pdf 파일로 만들어요.") //수정 다국어
                            .font(Font(uiFont: Constants.Font.bold(size: 16)))
                            .foregroundStyle(Color(uiColor: Constants.Color.Text.basicSubTitle))
                        
                    }//Vstack(spacing: 8)
                    
                    Button("내보내기") { //수정 다국어
                        Task { await viewModel.generatePDF() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(uiColor: Constants.Color.iconTint.basicBlack))
                    .foregroundStyle(Color(uiColor: Constants.Color.iconTint.basicWhite))
                    .font(Font(uiFont: Constants.Font.bold(size: 16)))
                    .controlSize(.large)
                    .disabled(viewModel.isGenerating)
                }//Vstack(spacing: 24)
                
                //ProgressView
                if viewModel.isGenerating {
                    
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.7)
                            .padding(.vertical, 8)
                        
                        VStack(spacing: 4) {
                            Text("내보내는 중...") //수정 다국어
                                .font(Font(uiFont: Constants.Font.bold(size: 15)))
                                .foregroundStyle(Color(uiColor: Constants.Color.Text.basicSubTitle))
                        }
                    }
                    .padding(32)
                    .background(Color(uiColor: Constants.Color.iconTint.basicWhite), in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color(uiColor: Constants.Color.Background.basicIcon).opacity(0.2), radius: 6)
                }
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .fileExporter(
                isPresented: $showExporter,
                document: viewModel.pdfData.map { PDFDataDocument(data: $0) } ?? PDFDataDocument(data: Data()),
                contentType: .pdf,
                defaultFilename: "감정일기_\(Date().formatted(date: .abbreviated, time: .omitted)).pdf" //수정 다국어
            ) { _ in }
                .onReceive(viewModel.$pdfData) { pdfData in
                    if pdfData != nil {
                        showExporter = true
                    }
                }
        }
    }
}

struct PDFDataDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.pdf] }
    var data: Data
    
    init(data: Data) { self.data = data }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}
