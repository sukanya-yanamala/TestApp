//
//  StoryCell.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 3/31/22.
//

import UIKit

class StoryCell: UITableViewCell {

    static let identifier = "StoryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .blue
        return label
    }()
    
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(storyImageView)
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        storyImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        storyImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        storyImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        storyImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20.0).isActive = true
    }
    
    func configureCell(title: String?, imageData: Data?) {
        titleLabel.text = title
        
        storyImageView.image = nil
        if let imageData = imageData {
            storyImageView.image = UIImage(data: imageData)
        }
    }
    
}
