//
//  MovieCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    let posterImageVieww = UIImageView()
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        
        posterImageVieww.contentMode = .scaleAspectFill
        posterImageVieww.layer.cornerRadius = 8
        posterImageVieww.clipsToBounds = true
        contentView.addSubview(posterImageVieww)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        posterImageVieww.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.height)
        }
        
    }
}
