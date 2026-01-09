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
                        Text("diaryExport_Placeholder".localized)
                            .font(Font(uiFont: Constants.Font.bold(size: 16)))
                            .foregroundStyle(Color(uiColor: Constants.Color.Text.basicSubTitle))
                        
                    }//Vstack(spacing: 8)
                    
                    Button("diaryExport_ExportButton_Title".localized) {
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
                            Text("diaryExport_Progress_Text".localized)
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
            .popup(isPresented: $viewModel.showingPopup) {
                ToastView(message: "diaryExport_Toast_Message".localized)
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring)
                    .autohideIn(1.5)
            }
            .fileExporter(
                isPresented: $showExporter,
                document: viewModel.pdfData.map { PDFDataDocument(data: $0) } ?? PDFDataDocument(data: Data()),
                contentType: .pdf,
                defaultFilename: String(format: "diaryExport_Filename_Prefix".localized,  Date().formatted(date: .abbreviated, time: .omitted))
                    //"감정일기_\(Date().formatted(date: .abbreviated, time: .omitted)).pdf"
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
