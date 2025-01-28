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
    let collectionView : UICollectionView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // CollectionView Layout Ayarları
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 150)
        layout.minimumLineSpacing = 10
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        contentView.addSubview(collectionView)
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(150)
            make.leading.top.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(posterImageView.snp.top)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.height.equalTo(150)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
extension MovieCell : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    
}
