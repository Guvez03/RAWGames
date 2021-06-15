//
//  ViewController.swift
//  AppCentProject
//
//  Created by ahmet on 9.06.2021.
//

import UIKit

class ViewController: UIViewController{
    
    var backGroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let imageBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var imageName: String = ""{
        didSet{
            backGroundImageView.setImage(imageUrl: imageName)
        }
    }
    
    var imageArr: [Results]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backGroundImageView)
        
        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backGroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(imageBtn)
        NSLayoutConstraint.activate([
            imageBtn.topAnchor.constraint(equalTo: backGroundImageView.topAnchor),
            imageBtn.bottomAnchor.constraint(equalTo: backGroundImageView.bottomAnchor),
            imageBtn.leadingAnchor.constraint(equalTo: backGroundImageView.leadingAnchor),
            imageBtn.trailingAnchor.constraint(equalTo: backGroundImageView.trailingAnchor),
        ])
        
        backGroundImageView.setImage(imageUrl: imageName)
        
        if let imageArray = imageArr {
            for index in 0 ... 3{
                //backGroundImageView.setImageKf(imageUrl:imageArray[index].background_image, imageView: backGroundImageView)
                backGroundImageView.setImage(imageUrl: imageArray[index].background_image)
            }
        }
        
    }
    
}

