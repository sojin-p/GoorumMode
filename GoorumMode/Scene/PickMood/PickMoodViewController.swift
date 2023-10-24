//
//  PickMoodViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/29.
//

import UIKit

final class PickMoodViewController: BaseViewController {
    
    private let mainView = PickMoodView()
    
    var completionHandler: ((String) -> Void)?
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSheet()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
}

extension PickMoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickMoodCollectionViewCell.identifier, for: indexPath) as? PickMoodCollectionViewCell else { return UICollectionViewCell() }
        
        let emojis = MoodEmojis.allCases[indexPath.item]
        cell.moodImage.image = emojis.image
        cell.moodImage.accessibilityLabel = emojis.accessLabel
        cell.moodImage.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emojiName = MoodEmojis.allCases[indexPath.item].rawValue
        completionHandler?(emojiName)
        dismiss(animated: true)
    }
}

extension PickMoodViewController {
    
    func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        
    }
}
