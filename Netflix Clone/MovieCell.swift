//
//  MovieCell.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 28.01.2025.
//

import UIKit
import SnapKit
class MovieCell: UITableViewCell {
    
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        contentView.addSubview(posterImageView)
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(80)
            make.leading.top.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(posterImageView.snp.top)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
