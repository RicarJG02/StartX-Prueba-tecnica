//
//  ViewController.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 28/3/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Properties
    
    var selectedMovieDetails: DetailResponse?
    var selectedMovie: Movie?
    var selectedIndexPath: IndexPath?
    var searchResults: [Movie] = []
    var selectedDetailsView: UIView?
    var networkManager = NetworkManager()
    var details: DetailResponse?

    // MARK: - UI Components
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search for a movie"
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.rowHeight = 200
        return tableView
    }()
    
    lazy var moviesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Movies"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let movieName = searchBar.text else { return }
        networkManager.searchMovies(with: movieName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.searchResults = movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error searching for movies: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let movie = searchResults[indexPath.row]
        configureCell(cell, with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < searchResults.count else {
            return
        }
        let movie = searchResults[indexPath.row]
        if selectedMovie == movie {
            selectedMovie = nil
            removeDetailsView()
            return
        }
        selectedMovie = movie
        networkManager.fetchDetails(for: movie.imdbID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let details):
                DispatchQueue.main.async {
                    self.showDetailsView(for: movie, with: details, at: indexPath)
                }
            case .failure(let error):
                print("Error fetching movie details: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }

    // MARK: - Helper Methods
    
    // Opens the selected movie's IMDb page in the system's default web browser.
    @objc func viewOnIMDb(_ sender: Any) {
        guard let selectedMovie = selectedMovie else {
            return
        }
        if let imdbURL = URL(string: "https://www.imdb.com/title/\(selectedMovie.imdbID)") {
            UIApplication.shared.open(imdbURL)
        }
    }
    
    // MARK: - Private Functions
    
    private func showMovieDetails(for movie: Movie) {
        networkManager.fetchDetails(for: movie.imdbID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let detailResponse):
                let message = "Director: \(detailResponse.director)\nPlot: \(detailResponse.plot)"
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: detailResponse.title, message: message, preferredStyle: .actionSheet)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Error fetching movie details: \(error.localizedDescription)")
            }
        }
    }
}
