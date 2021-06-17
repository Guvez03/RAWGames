//
//  UIImageView+Extension.swift
//  AppCentProject
//
//  Created by ahmet on 11.06.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(imageUrl: String) {
        self.kf.setImage(with: URL(string: imageUrl))
    }
    func setImageKf(imageUrl: String,imageView: UIImageView){
        if let imageURL = URL(string: imageUrl) {
            let resource = ImageResource(downloadURL:imageURL )
            imageView.kf.setImage(
                with: resource,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .processor(DownsamplingImageProcessor(size: imageView.frame.size)),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ])
        }
    }
}
