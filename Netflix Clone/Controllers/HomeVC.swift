//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 27.01.2025.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    // MARK: - Properties
    var movieViewModel = MovieViewModel()
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    var popularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 105, height: 175)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    var topRatedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 105, height: 175)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var popularMovieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 500)
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    let popularTitleLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var movies: [Movie] = []
    var topRated: [Movie] = []
    let topRatedTitleLabel = UILabel()
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupConstraints()
        setupViewModel()
        loadInitialData()
        
        // MARK: - Save MovieCollectionViewCell
        popularCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        topRatedCollectionView.register(TopRatedCollectionViewCell.self, forCellWithReuseIdentifier: "TopRatedCollectionViewCell")
        popularMovieCollectionView.register(PopularMovieCollectionViewCell.self, forCellWithReuseIdentifier: "PopularMovieCollectionViewCell")

    }

    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        scrollView.addSubview(stackView)
        
        popularMovieCollectionView.backgroundColor = .clear
        popularMovieCollectionView.showsHorizontalScrollIndicator = false
        popularMovieCollectionView.delegate = self
        popularMovieCollectionView.dataSource = self
        popularMovieCollectionView.register(PopularMovieCollectionViewCell.self, forCellWithReuseIdentifier: "PopularMovieCollectionViewCell")
        stackView.addArrangedSubview(popularMovieCollectionView)
        
        popularTitleLabel.textColor = .label
        popularTitleLabel.numberOfLines = 1
        popularTitleLabel.textAlignment = .left
        popularTitleLabel.font = .boldSystemFont(ofSize: 17)
        popularTitleLabel.text = "Popular Movies"
        stackView.addArrangedSubview(popularTitleLabel)
        
        
        popularCollectionView.backgroundColor = .clear
        popularCollectionView.showsHorizontalScrollIndicator = false
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        stackView.addArrangedSubview(popularCollectionView)
        
        topRatedTitleLabel.textColor = .label
        topRatedTitleLabel.numberOfLines = 1
        topRatedTitleLabel.textAlignment = .left
        topRatedTitleLabel.font = .boldSystemFont(ofSize: 17)
        topRatedTitleLabel.text = "Top Rated Movies"
        stackView.addArrangedSubview(topRatedTitleLabel)
        
        topRatedCollectionView.backgroundColor = .clear
        topRatedCollectionView.showsHorizontalScrollIndicator = false
        topRatedCollectionView.delegate = self
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.register(TopRatedCollectionViewCell.self, forCellWithReuseIdentifier: "TopRatedCollectionViewCell")
        stackView.addArrangedSubview(topRatedCollectionView)
        
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(13)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide) // ScrollView'in içeriğine bağla
            make.width.equalTo(scrollView.frameLayoutGuide)// Genişlik sabit kalmalı
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        popularMovieCollectionView.snp.makeConstraints { make in
            make.height.equalTo(550)
        }
        popularTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        
        popularCollectionView.snp.makeConstraints { make in
            make.height.equalTo(175)
        }
        topRatedTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        topRatedCollectionView.snp.makeConstraints { make in
            make.height.equalTo(175)
        }
    }
    
    // MARK: - ViewModel Setup
    private func setupViewModel() {
        movieViewModel.delegate = self
    }
    // MARK: - Load Data
    private func loadInitialData() {
        activityIndicator.startAnimating()
        Task {
            await movieViewModel.loadMoviesAndGenres()
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

// MARK: - MovieViewModelDelegate
extension HomeVC: MovieViewModelDelegate {
    // MARK: - MovieViewModelDelegate Methods
    func moviesDidUpdate(movies: [Movie]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.movies = movies
            self.topRated = movies
            self.popularCollectionView.reloadData()
            self.topRatedCollectionView.reloadData()
            self.popularMovieCollectionView.reloadData()
        }
    }
    
    func genresDidUpdate(genres: [Genre]) {
        print("\(genres)")
    }
    
    func isLoadingDidChange(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    

    
    // MARK: - Error Handling Methods
    func errorDidOccur(message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}


// MARK: - UICollectionView Delegate & DataSource
extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topRatedCollectionView {
            return topRated.count
        }
        return movies.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topRatedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCollectionViewCell", for: indexPath) as! TopRatedCollectionViewCell
            let movie = topRated[indexPath.row]
            cell.voteLabel.text = "\(movie.vote)"
            if let url = movie.posterURL {
                loadImage(from: url) { image in
                    cell.posterImageView2.image = image
                    
                }
            }
            return cell
        }else if collectionView == popularMovieCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMovieCollectionViewCell", for: indexPath) as! PopularMovieCollectionViewCell
            let movie = movies[indexPath.row]
            if let url = movie.posterURL {
                loadImage(from: url) { image in
                    cell.imageView.image = image
                    
                }
            }

            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
            
        if let url = movie.posterURL {
            loadImage(from: url) { image in
                cell.posterImageVieww.image = image
            }
        }
        return cell
        
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        dismiss(animated: true, completion: nil)
        let dVC = DetailVC()
        dVC.movie = movies[indexPath.row]
        self.present(dVC, animated: true, completion: nil)
    }
    
}

