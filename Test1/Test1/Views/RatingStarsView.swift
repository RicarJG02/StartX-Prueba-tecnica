//
//  RatingStarsView.swift
//  Test1
//
//  Created by Ricardo Guerrero Godínez on 29/3/23.
//

import UIKit

class RatingStarsView: UIView {
    
    private let starSize: CGFloat = 20
    private let spacing: CGFloat = 5
    private let maxRating: Int = 10
    private let starImageName: String = "star.fill"
    
    private var rating: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var starImageViews: [UIImageView] = []
    
    init(ratings: Ratings) {
        let doubleValue = Double(ratings.value.replacingOccurrences(of: "/10", with: "")) ?? 0.0
        self.rating = Int(doubleValue.rounded())
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupSubviews() {
        for i in 0..<maxRating {
            let imageView = UIImageView(image: UIImage(systemName: starImageName))
            imageView.tintColor = i < rating ? .systemYellow : .systemGray
            imageView.contentMode = .scaleAspectFit
            imageView.frame.size = CGSize(width: starSize, height: starSize)
            imageView.frame.origin = CGPoint(x: CGFloat(i) * (starSize + spacing), y: 0)
            addSubview(imageView)
            starImageViews.append(imageView)
        }
        
        let label = UILabel()
        label.text = "\(rating)/10"
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        addSubview(label)
        label.frame.origin = CGPoint(x: maxRating * Int((starSize + spacing)), y: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for i in 0..<maxRating {
            let imageView = starImageViews[i]
            imageView.tintColor = i < rating ? .systemYellow : .systemGray
        }
    }
}
