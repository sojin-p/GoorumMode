//
//  PickMoodViewController.swift
//  GoorumMode
//
//  Created by 박소진 on 2023/09/29.
//

import UIKit

final class PickMoodViewController: BaseViewController {
    
    private let mainView = PickMoodView()
    
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
        
        cell.moodImage.image = UIImage(systemName: "heart")
        cell.moodImage.contentMode = .scaleAspectFit
        
        return cell
    }
}

extension PickMoodViewController {
    
    func setupSheet() {
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 20
            sheet.prefersGrabberVisible = true
        }
        
    }
}
