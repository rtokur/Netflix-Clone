//
//  DetailVC.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 30.01.2025.
//

import UIKit

class DetailVC: UIViewController {
    let imageView = UIImageView()
//    let view2 = UIView()
//    let playButton = UIButton()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let dateLabel = UILabel()
    let playButton2 = UIButton()
    let descriptionLabel = UILabel()
    let titleLabel = UILabel()
    var movie = Movie(id: 0, title: "", overview: "", releaseDate: "", posterPath: "",genreIds: [],vote: 0.0)
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        view.addSubview(scrollView)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        if let url = movie.posterURL {
            loadImage(from: url) { image in
                self.imageView.image = image
            }
        }
        stackView.addArrangedSubview(imageView)
        
        titleLabel.numberOfLines = 1
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .left
        titleLabel.text = movie.title
        stackView.addArrangedSubview(titleLabel)
        
        dateLabel.numberOfLines = 1
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textAlignment = .left
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: movie.releaseDate ?? "0000-00-00")
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date!)
        dateLabel.text = year
        stackView.addArrangedSubview(dateLabel)
        
        playButton2.backgroundColor = .label
        playButton2.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        playButton2.tintColor = .systemBackground
        playButton2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        playButton2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        playButton2.setTitle("Play", for: .normal)
        playButton2.setTitleColor(.systemBackground, for: UIControl.State.normal)
        playButton2.layer.cornerRadius = 3
        stackView.addArrangedSubview(playButton2)

//        view2.layer.cornerRadius = 8
//        view2.clipsToBounds = true
//        stackView.addArrangedSubview(view2)
//        
//        playButton.backgroundColor = .white.withAlphaComponent(0.85)
//        playButton.setImage(UIImage(systemName: "play.fill"),for: UIControl.State.normal)
//        playButton.tintColor = .black
//        playButton.layer.cornerRadius = 8
//        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
//        view2.addSubview(playButton)
        
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = movie.overview
        descriptionLabel.numberOfLines = .max
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    @objc func playButtonAction(sender: UIButton) {
        print("play button tapped")
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(13)
            make.leading.trailing.equalTo(scrollView).inset(13)
            make.width.equalTo(scrollView).inset(13)
        }

        imageView.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(230)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        playButton2.snp.makeConstraints { make in
            make.width.equalTo(stackView)
            make.height.equalTo(40)
        }
//        view2.snp.makeConstraints { make in
//            make.height.equalTo(50)
//            make.centerX.equalTo(imageView)
//            make.width.equalTo(imageView.snp.width).dividedBy(2)
//        }
//        playButton.snp.makeConstraints { make in
//            make.height.equalToSuperview()
//            
//        }
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
    }
    // MARK: - Image Loading Methods
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
