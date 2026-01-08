//
//  DiaryExportViewModel.swift
//  GoorumMode
//
//  Created by 박소진 on 1/1/26.
//

import SwiftUI
import RealmSwift

@MainActor
class DiaryExportViewModel: ObservableObject {
    private let repository: MoodRepository
    private let pdfGenerator: PDFGenerator
    
    @Published var isGenerating = false
    @Published var pdfData: Data?
    
    init(repository: MoodRepository = MoodRepository(), pdfGenerator: PDFGenerator = PDFGenerator()) {
        self.repository = repository
        self.pdfGenerator = pdfGenerator
    }
    
    func generatePDF() async {
        await MainActor.run { isGenerating = true }
        
        defer {  //항상 실행
            Task { @MainActor in
                isGenerating = false
            }
        }
        
        let moods = repository.fetchAllMoods()
        
        pdfData = pdfGenerator.generate(from: moods)
        
    }
}
