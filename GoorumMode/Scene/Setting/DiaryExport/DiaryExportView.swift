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
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("📄 일기 PDF 내보내기")
                    .font(.title2.bold())
                Text("저장된 모든 일기를 PDF로 만들어요")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Button("PDF 생성 & 공유") {
                Task { await viewModel.generatePDF() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isGenerating)
            
            Button("디버그: 전체 데이터 확인") {
                let count = MoodRepository().fetchAllMoods().count
                print("📊 전체 Mood: \(count)개")
            }
            
            if viewModel.isGenerating {
                ProgressView("PDF 생성 중...")
                    .padding()
            }
        }
        .padding()
        .navigationTitle("PDF 내보내기")
        .navigationBarTitleDisplayMode(.inline)
        .fileExporter(
            isPresented: $showExporter,
            document: viewModel.pdfData.map { PDFDataDocument(data: $0) } ?? PDFDataDocument(data: Data()),
            contentType: .pdf,
            defaultFilename: "감정일기_\(Date().formatted(date: .abbreviated, time: .omitted)).pdf"
        ) { _ in }
            .onReceive(viewModel.$pdfData) { pdfData in
                if pdfData != nil {
                    showExporter = true
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
