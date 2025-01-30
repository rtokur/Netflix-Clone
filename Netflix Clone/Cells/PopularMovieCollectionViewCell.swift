//
//  PopularSeriesCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 30.01.2025.
//

import UIKit
import SnapKit
class PopularMovieCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
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
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.height)
        }
        
    }
}
