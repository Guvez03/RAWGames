//
//  GamesTableViewCell.swift
//  AppCentProject
//
//  Created by ahmet on 11.06.2021.
//

import UIKit

class GamesTableViewCell: UITableViewCell {
    
    static let cellId = "cellId"
    
    let gameBackgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let gameName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let gameRating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        contentView.addSubview(gameBackgroundImage)
        contentView.addSubview(gameName)
        contentView.addSubview(gameRating)
        
        NSLayoutConstraint.activate([
            gameBackgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            gameBackgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            gameBackgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            gameBackgroundImage.heightAnchor.constraint(equalToConstant: contentView.frame.height - 10),
            gameBackgroundImage.widthAnchor.constraint(equalToConstant: contentView.frame.height * 2)
        ])
        
        NSLayoutConstraint.activate([
            gameName.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            gameName.leadingAnchor.constraint(equalTo: gameBackgroundImage.trailingAnchor,constant: 15),
            gameName.heightAnchor.constraint(equalToConstant: (contentView.frame.height) / 2)
        ])
        
        NSLayoutConstraint.activate([
            gameRating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            gameRating.leadingAnchor.constraint(equalTo: gameBackgroundImage.trailingAnchor,constant: 15),
            gameRating.heightAnchor.constraint(equalToConstant: (contentView.frame.height) / 2)
        ])
        
    }
    
}
