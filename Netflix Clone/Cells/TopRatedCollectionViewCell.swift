//
//  TopRatedCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 29.01.2025.
//

import UIKit
import SnapKit
class TopRatedCollectionViewCell: UICollectionViewCell {
    let posterImageView2 = UIImageView()
    let voteLabel = UILabel()
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        voteLabel.textColor = .label
        voteLabel.font = .italicSystemFont(ofSize: 15)
        voteLabel.textAlignment = .center
        contentView.addSubview(voteLabel)
        
        posterImageView2.contentMode = .scaleAspectFill
        posterImageView2.layer.cornerRadius = 8
        posterImageView2.clipsToBounds = true
        contentView.addSubview(posterImageView2)
        
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        posterImageView2.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.height)
        }
        voteLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView2.snp.bottom)
        }
        
    }
}
