//
//  QuestionContentCollectionView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 10.02.2021.
//

import UIKit
import AVFoundation

class QuestionContentCollectionView: UICollectionView {

    private lazy var elements = [QuestionContentType]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(elements: [QuestionContentType]) {
        self.elements = elements
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension QuestionContentCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: QuestionCollectionCell.self), for: indexPath) as! QuestionCollectionCell
        cell.setup(content: element)
        return cell
    }
    
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension QuestionContentCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("Wrong layout type supplied")
            return .zero
        }
        
        let cellWidth = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let cellHeight = collectionView.frame.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom

        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension QuestionContentCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        switch element {
        case let .video(url):
            (cell as! QuestionCollectionCell).videoView.player = AVPlayer(url: url)
            (cell as! QuestionCollectionCell).videoView.player?.play()
        case .image:
            break
        }
    }
}

// MARK: Private
private extension QuestionContentCollectionView {
    func initialize() {
        backgroundColor = .clear
        register(QuestionCollectionCell.self, forCellWithReuseIdentifier: String(describing: QuestionCollectionCell.self))
        dataSource = self
        delegate = self
    }
}
