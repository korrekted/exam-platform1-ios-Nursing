//
//  QuestionCollectionCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 10.02.2021.
//

import UIKit
import AVFoundation

class QuestionCollectionCell: UICollectionViewCell {
    
    private lazy var questionImageView = makeImageView()
    lazy var videoView = makeVideoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(content: QuestionContentType) {
        switch content {
        case let .image(url):
            videoView.isHidden = true
            questionImageView.isHidden = false
            do {
                try questionImageView.image = UIImage(data: Data(contentsOf: url))
            } catch {
                
            }
        case .video:
            videoView.isHidden = false
            questionImageView.isHidden = true
        }
    }
}

// MARK: Private
private extension QuestionCollectionCell {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension QuestionCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            questionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            questionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            questionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            questionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 20.scale
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }
    
    func makeVideoView() -> AVPlayerView {
        let view = AVPlayerView()
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }
}
