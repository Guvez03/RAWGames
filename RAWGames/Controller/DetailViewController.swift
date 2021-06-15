//
//  DetailViewController.swift
//  AppCentProject
//
//  Created by ahmet on 10.06.2021.
//

import UIKit
import Alamofire
import CoreData

class DetailViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let gameName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let metacriticName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let descriptionName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    var detailViewModel = DetailViewModel()
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if let ID = id {
            detailViewModel.fetchData(id: ID)
        }
        
        detailViewModel.onUpdate = { [weak self] favoriteGame  in
            
            self?.imageView.setImage(imageUrl: favoriteGame.background_image ?? "")
            self?.gameName.text = favoriteGame.name
            self?.dateLabel.text = favoriteGame.released
            self?.metacriticName.text = "\(favoriteGame.rating )"
            let str = favoriteGame.attDescription?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            self?.descriptionName.text = str
            favoriteGame.isSelected ? self?.likeButton.setBackgroundImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal) : self?.likeButton.setBackgroundImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            
        }
        
        detailViewModel.onUpdateArray = { [weak self] detailArray in
            
            self?.imageView.setImage(imageUrl: detailArray.background_image ?? "")
            self?.gameName.text = detailArray.name
            self?.dateLabel.text = detailArray.released
            self?.metacriticName.text = "\(detailArray.rating ?? 0.0)"
            let str = detailArray.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            self?.descriptionName.text = str
        }
        
    }
    
    @objc func touchLiked(){
        
        guard  let ID = id else{
            return
        }
        
        let isSelected = detailViewModel.touchLiked(id: ID)
        isSelected ?  likeButton.setBackgroundImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal): likeButton.setBackgroundImage(UIImage(systemName: "hand.thumbsup"), for: .normal)      
    }
    
    @objc func backBtnTouched(){
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        imageView.backgroundColor = .black
        
        view.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant: -15),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: -15),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        likeButton.setBackgroundImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        likeButton.tintColor = .red
        
        view.addSubview(backBtn)
        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: imageView.topAnchor,constant: 20),
            backBtn.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,constant: 20),
            backBtn.heightAnchor.constraint(equalToConstant: 30),
            backBtn.widthAnchor.constraint(equalToConstant: 25),
        ])
        backBtn.addTarget(self, action:  #selector(backBtnTouched), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(bottomView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
        ])
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,constant: 0),
            bottomView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        bottomView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: bottomView.topAnchor,constant: 10),
            containerView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor,constant: -15),
            containerView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor,constant: 15),
            
        ])
        
        containerView.addArrangedSubview(gameName)
        containerView.addArrangedSubview(dateLabel)
        containerView.addArrangedSubview(metacriticName)
        containerView.arrangedSubviews.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        dateLabel.text = ""
        gameName.text = ""
        metacriticName.text = ""
        
        bottomView.addSubview(descriptionName)
        NSLayoutConstraint.activate([
            descriptionName.topAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 15),
            descriptionName.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor,constant: -15),
            descriptionName.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor,constant: 15),
            descriptionName.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor,constant: 0),
        ])
        descriptionName.numberOfLines = 0
        
        descriptionName.text = ""
        
        likeButton.addTarget(self, action: #selector(self.touchLiked), for: .touchUpInside)
    }
    
}
