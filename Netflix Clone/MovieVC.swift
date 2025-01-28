//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Rumeysa Tokur on 27.01.2025.
//

import UIKit
import SnapKit

class MovieVC: UIViewController {
    private var movieViewModel = MovieViewModel()
    
    private let stackView = UIStackView()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
        setupConstraints()
        setupViewModel()
        loadInitialData()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        view.addSubview(stackView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupViewModel(){
        movieViewModel.delegate = self
    }

    private func loadInitialData(){
        activityIndicator.startAnimating()
        Task {
            await movieViewModel.loadMoviesAndGenres()
        }
    }
}

extension MovieVC : MovieViewModelDelegate {
    func moviesDidUpdate(movies: [Movie]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func genresDidUpdate(genres: [Genre]) {
        print("Genres updates: \(genres)")
    }
    
    func isLoadingDidChange(isLoading : Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func errorDidOccur(message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert,animated: true)
        }
    }
}

extension MovieVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movieViewModel.movies[indexPath.row]
        
        // Set movie title and description
        cell.titleLabel.text = movie.title
        cell.descriptionLabel.text = movie.overview
        
        // Load image asynchronously
        if let url = movie.posterURL {
            loadImage(from: url) { image in
                cell.posterImageView.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movieViewModel.movies[indexPath.row]
        print("Selected movie: \(movie.title)")
    }
}

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

