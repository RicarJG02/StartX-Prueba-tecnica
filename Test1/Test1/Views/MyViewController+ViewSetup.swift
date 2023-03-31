//
//  MyViewController+ViewSetup.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 30/3/23.
//

import UIKit

extension ViewController {
    
    // MARK: - SearchBarDelegate

    func setupViews() {
        view.addSubview(moviesLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            moviesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moviesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: moviesLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        moviesLabel.layoutIfNeeded()
        moviesLabel.layer.cornerRadius = 20
        moviesLabel.layer.masksToBounds = true
    }
    
    func createLabel(withText text: String, font: UIFont, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = font
        label.numberOfLines = numberOfLines
        label.text = text
        return label
    }
    
    func setupDetailsView(_ detailsView: UIView, for movie: Movie, with details: DetailResponse) {
        let titleLabel = createLabel(withText: movie.title, font: .systemFont(ofSize: 20, weight: .bold))
        let plotLabel = createLabel(withText: details.plot, font: .systemFont(ofSize: 14, weight: .regular), numberOfLines: 0)
        let directorLabel = createLabel(withText: "Director:", font: .systemFont(ofSize: 16, weight: .medium))
        let directorValueLabel = createLabel(withText: details.director, font: .systemFont(ofSize: 14, weight: .regular), numberOfLines: 0)
        let ratingValue = details.ratings.first?.value.replacingOccurrences(of: "/10", with: "") ?? "0"
        let rating = Ratings(value: ratingValue)
        let ratingStarsView = RatingStarsView(ratings: rating)
        
        let views = [titleLabel, plotLabel, directorLabel, directorValueLabel, ratingStarsView]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        views.forEach(detailsView.addSubview)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -10),
            
            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            plotLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 10),
            plotLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -10),
            
            directorLabel.topAnchor.constraint(equalTo: plotLabel.bottomAnchor, constant: 20),
            directorLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 10),
            
            directorValueLabel.topAnchor.constraint(equalTo: directorLabel.topAnchor),
            directorValueLabel.leadingAnchor.constraint(equalTo: directorLabel.trailingAnchor, constant: 10),
            directorValueLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -10),
            
            ratingStarsView.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 20),
            ratingStarsView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 10),
            ratingStarsView.widthAnchor.constraint(equalToConstant: 120),
            ratingStarsView.heightAnchor.constraint(equalToConstant: 20),
            ratingStarsView.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: -10),
        ])
    }
    
    func createDetailsView(for movie: Movie, with details: DetailResponse) -> UIView {
        let detailsView = UIView()
        detailsView.backgroundColor = .white
        setupDetailsView(detailsView, for: movie, with: details)
        return detailsView
    }
    
    func setupDetailsViewConstraints(for detailsView: UIView, below cell: UITableViewCell) {
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: 8),
            detailsView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 208)
        ])
    }
    
    func showDetailsView(for movie: Movie, with details: DetailResponse, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let superview = cell.superview else {
            return
        }
        removeDetailsView()
        let detailsView = createDetailsView(for: movie, with: details)
        superview.addSubview(detailsView)
        selectedDetailsView = detailsView
        setupDetailsViewConstraints(for: detailsView, below: cell)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func removeDetailsView() {
        selectedDetailsView?.removeFromSuperview()
        selectedDetailsView = nil
    }
    
    // MARK: - Cell Configuration
    
    func configureCell(_ cell: UITableViewCell, with movie: Movie) {
        configureTextLabels(for: cell, with: movie)
        configureImageView(for: cell, with: movie)
        configureDetailsView(for: cell, with: movie)
        configureAccessoryView(for: cell, with: movie)
    }
    
    private func configureTextLabels(for cell: UITableViewCell, with movie: Movie) {
        cell.textLabel?.text = "\(movie.title)"
        cell.detailTextLabel?.text = "(\(movie.year))"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: .thin)
    }
    
    private func configureImageView(for cell: UITableViewCell, with movie: Movie) {
        cell.imageView?.layer.cornerRadius = 10
        cell.imageView?.clipsToBounds = true
        
        if let posterURL = movie.posterURL {
            URLSession.shared.dataTask(with: posterURL) { data, response, error in
                if let data = data {
                    print("Image data received successfully")
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        let size = CGSize(width: 80, height: 120)
                        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                        image?.draw(in: CGRect(origin: .zero, size: size))
                        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        cell.imageView?.image = scaledImage
                        cell.setNeedsLayout()
                    }
                } else {
                    print("Error receiving image data: \(error?.localizedDescription ?? "unknown error")")
                }
            }.resume()
        }
    }
    
    private func configureDetailsView(for cell: UITableViewCell, with movie: Movie) {
        if let selectedMovie = selectedMovie, selectedMovie.imdbID == movie.imdbID {
            let detailsTask = URLSession.shared.detailTask(with: selectedMovie.imdbID) { (result: Result<DetailResponse, Error>) in
                switch result {
                case .success(let details):
                    DispatchQueue.main.async {
                        let detailsView = UIView(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: 200))
                        detailsView.backgroundColor = .white
                        cell.contentView.addSubview(detailsView)
                        self.setupDetailsView(detailsView, for: movie, with: details)
                        cell.imageView?.image = nil
                    }
                case .failure(let error):
                    print(error)
                }
            }
            detailsTask.resume()
        } else {
            cell.contentView.subviews.filter({ $0 is UIView }).forEach({ $0.removeFromSuperview() })
        }
    }
    
    private func configureAccessoryView(for cell: UITableViewCell, with movie: Movie) {
        if let selectedMovie = selectedMovie, selectedMovie.imdbID == movie.imdbID {
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.accessoryView = nil
        } else {
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.down"))
            cell.accessoryView?.tintColor = .gray
        }
    }
}
