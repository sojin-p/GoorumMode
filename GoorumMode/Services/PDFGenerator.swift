//
//  PDFGenerator.swift
//  GoorumMode
//
//  Created by 박소진 on 1/1/26.
//

import UIKit
import CoreText

struct PDFGenerator {
    
    // MARK: - Layout constants
    private let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842) //A4
    private let leftMargin: CGFloat = 40
    private let rightMargin: CGFloat = 40
    private let topMargin: CGFloat = 60
    private let bottomMargin: CGFloat = 60
    
    private var contentWidth: CGFloat { pageRect.width - leftMargin - rightMargin }
    private var maxY: CGFloat { pageRect.height - bottomMargin }
    
    // MARK: - Fonts
    private let dateFont = Constants.Font.extraBold(size: 14)
    private let oneLineFont = Constants.Font.bold(size: 14)
    private let bodyFont = Constants.Font.bold(size: 14)
    
    // MARK: - Spacing
    private let blockTopPadding: CGFloat = 12      //한 기록 시작 전 여백
    private let blockBottomPadding: CGFloat = 18   //한 기록 끝난 후 여백

    private let spaceAfterDate: CGFloat = 10
    private let spaceAfterEmotion: CGFloat = 12
    private let spaceAfterOneLine: CGFloat = 10
    private let spaceAfterDetail: CGFloat = 8
    
    func generate(from moods: [Mood]) -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        return renderer.pdfData { context in
            let calendar = Calendar(identifier: .gregorian)
            
            let formatter = createDateFormatter()
            
            //날짜순 정렬
            let sorted = moods.sorted { $0.date < $1.date }
            
            context.beginPage()
            var y = topMargin
            var prevDate: Date? = nil
            
            for mood in sorted {
                
                //날짜가 바뀔 때만 구분선
                if let prev = prevDate, !calendar.isDate(prev, inSameDayAs: mood.date) {
                    y = ensureSpace(minHeight: 18, y: y, context: context)
                    drawSeparatorLine(y: y, context: context)
                    y += 18
                }
                prevDate = mood.date
                
                //블록 시작 여백
                y = ensureSpace(minHeight: blockTopPadding + 80, y: y, context: context)
                y += blockTopPadding
                
                //날짜
                let dateText = formatter.string(from: mood.date)
                NSAttributedString(
                    string: dateText,
                    attributes: [.font: dateFont]
                ).draw(in: CGRect(x: leftMargin, y: y, width: contentWidth, height: 22))
                y += 22 + spaceAfterDate
                
                //감정 이미지
                if let emotionImage = UIImage(named: mood.mood) {
                    emotionImage.draw(in: CGRect(x: leftMargin, y: y, width: 44, height: 44))
                }
                y += 44 + spaceAfterEmotion
                
                //한줄 내용
                if let oneLine = mood.onelineText, !oneLine.isEmpty {
                    y = ensureSpace(minHeight: 18, y: y, context: context)
                    NSAttributedString(
                        string: oneLine,
                        attributes: [.font: oneLineFont]
                    ).draw(in: CGRect(x: leftMargin, y: y, width: contentWidth, height: 18))
                    y += 18 + spaceAfterOneLine
                }
                
                //상세 내용
                if let detail = mood.detailText, !detail.isEmpty {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineBreakMode = .byWordWrapping
                    paragraph.lineSpacing = 3 //줄 사이 간격
                    
                    let detailAttr = NSAttributedString(
                        string: detail,
                        attributes: [.font: bodyFont, .paragraphStyle: paragraph]
                    )
                    
                    y = drawAttributedTextPaged(detailAttr, startY: y, context: context)
                    y += spaceAfterDetail
                }
                
                //블록 끝 여백
                y += blockBottomPadding
            }
        }
    }
    
    // MARK: - Page helpers
    
    private func createDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Bundle.main.preferredLocalizations.first ?? "ko_KR")
        formatter.dateFormat = DateFormatType.detailedDate.description
        return formatter
    }
    
    private func ensureSpace(minHeight: CGFloat, y: CGFloat, context: UIGraphicsPDFRendererContext) -> CGFloat {
        if y + minHeight > maxY {
            context.beginPage()
            return topMargin
        }
        return y
    }
    
    private func drawSeparatorLine(y: CGFloat, context: UIGraphicsPDFRendererContext) {
        let cg = context.cgContext
        cg.saveGState()
        cg.setStrokeColor(UIColor.separator.cgColor)
        cg.setLineWidth(1)
        cg.move(to: CGPoint(x: leftMargin, y: y))
        cg.addLine(to: CGPoint(x: pageRect.width - rightMargin, y: y))
        cg.strokePath()
        cg.restoreGState()
    }
    
    // MARK: - CoreText paging
    //NSAttributedString을 잘린 곳부터 이어서 여러 페이지에 걸쳐 출력
    private func drawAttributedTextPaged(_ attr: NSAttributedString, startY: CGFloat, context: UIGraphicsPDFRendererContext) -> CGFloat {
        
        //NSAttributedString는 isEmpty가 없으므로 length로 체크
        if attr.length == 0 { return startY }
        
        let framesetter = CTFramesetterCreateWithAttributedString(attr)
        var y = startY
        var startIndex = 0
        
        while startIndex < attr.length {
            
            //현재 페이지에서 사용 가능한 높이
            var availableHeight = maxY - y
            if availableHeight < 24 {
                context.beginPage()
                y = topMargin
                availableHeight = maxY - y
            }
            
            //이번 페이지에 그릴 frame 생성 (startIndex부터, 높이는 availableHeight)
            let cg = context.cgContext
            cg.saveGState()
            
            //UIKit(위 -> 아래) 좌표계를 CoreText(아래 -> 위)용으로 뒤집기
            cg.textMatrix = .identity
            cg.translateBy(x: 0, y: pageRect.height)
            cg.scaleBy(x: 1, y: -1)
            
            //CoreText 좌표에서의 rect (y 변환!)
            let coreTextRect = CGRect(
                x: leftMargin,
                y: pageRect.height - (y + availableHeight),
                width: contentWidth,
                height: availableHeight
            )
            
            let path = CGPath(rect: coreTextRect, transform: nil)
            let frame = CTFramesetterCreateFrame(
                framesetter,
                CFRange(location: startIndex, length: 0),
                path,
                nil
            )
            
            //실제로 "보이는" 텍스트 길이(=이번 페이지에 그려진 분량)
            let visible = CTFrameGetVisibleStringRange(frame)
            
            //방어코드: 혹시라도 0이면 무한루프 방지
            if visible.length == 0 {
                cg.restoreGState()
                context.beginPage()
                y = topMargin
                continue
            }
            
            CTFrameDraw(frame, cg)
            cg.restoreGState()
            
            //다음 시작점으로 이동 (반복 출력 방지)
            startIndex += visible.length
            
            //텍스트가 더 남아있으면 바로 다음 페이지로 이어서
            if startIndex < attr.length {
                context.beginPage()
                y = topMargin
            } else {
                //마지막 페이지라면, 실제 사용 높이만큼만 y 증가
                let usedSize = CTFramesetterSuggestFrameSizeWithConstraints(
                    framesetter,
                    CFRange(location: startIndex - visible.length, length: visible.length),
                    nil,
                    CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude),
                    nil
                )
                y += ceil(usedSize.height)
            }
        }
        
        return y
    }
}
