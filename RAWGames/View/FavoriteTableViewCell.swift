//
//  FavoriteTableViewCell.swift
//  AppCentProject
//
//  Created by ahmet on 12.06.2021.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    static let cellId = "cellId"
    
    let gameBackgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    var onUpdate = {}
    
    var favoriteGameViewModel = FavoriteGameViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupAutoLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
        likeButton.tintColor = .red
    }
    func setupAutoLayout(){
        
        contentView.addSubview(gameBackgroundImage)
        contentView.addSubview(gameName)
        contentView.addSubview(gameRating)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            gameBackgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            gameBackgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            gameBackgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            gameBackgroundImage.heightAnchor.constraint(equalToConstant: contentView.frame.height - 10),
            gameBackgroundImage.widthAnchor.constraint(equalToConstant: contentView.frame.height * 2)
        ])
        NSLayoutConstraint.activate([
            likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15),
            likeButton.heightAnchor.constraint(equalToConstant: contentView.frame.height / 2),
            likeButton.widthAnchor.constraint(equalToConstant: contentView.frame.height / 2)
        ])
        NSLayoutConstraint.activate([
            gameName.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            gameName.leadingAnchor.constraint(equalTo: gameBackgroundImage.trailingAnchor,constant: 15),
            gameName.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor,constant: 5),
            gameName.heightAnchor.constraint(equalToConstant: (contentView.frame.height) / 2)
        ])
        
        NSLayoutConstraint.activate([
            gameRating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            gameRating.leadingAnchor.constraint(equalTo: gameBackgroundImage.trailingAnchor,constant: 15),
            gameName.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor,constant: 5),
            gameRating.heightAnchor.constraint(equalToConstant: (contentView.frame.height) / 2)
        ])
        
        likeButton.addTarget(self, action: #selector(likeBtnTourched), for: .touchUpInside)
        
    }
    @objc func likeBtnTourched(){
        onUpdate()
    }
    func configure(index:Int){
        
        let favoriteGame = favoriteGameViewModel.games[index]
        gameBackgroundImage.setImage(imageUrl:favoriteGame.background_image ?? "")
        gameName.text = favoriteGame.name
        gameRating.text = "\(favoriteGame.rating) - \(favoriteGame.released ?? "")"
        likeButton.setBackgroundImage(UIImage(systemName:"hand.thumbsup"), for: .normal)
        favoriteGame.isSelected ? likeButton.setBackgroundImage(UIImage(systemName:"hand.thumbsup.fill"), for: .normal) :                 likeButton.setBackgroundImage(UIImage(systemName:"hand.thumbsup"), for: .normal)
   
    }
}
