//
//  DetailViewModel.swift
//  AppCentProject
//
//  Created by ahmet on 14.06.2021.
//

import Foundation

class DetailViewModel {
    
    var detailArray: GameDetailModel?
    let coreDataManager: CoreDataManager = CoreDataManager()
    var onUpdate: (FavoriteGame) -> Void = {_ in}
    var onUpdateArray: (GameDetailModel) -> Void = {_ in}
        
    func fetchData(id:Int){
        DispatchQueue.main.async {
            if let favoriteData = self.coreDataManager.getFavorite(id) {
                self.onUpdate(favoriteData)
            }else {
                APIService.shared.getFavoriteGames(id) { (result) in
                    
                    switch result {
                    case.success(let favoriteGame):
                        self.detailArray = favoriteGame
                        if let detailArr = self.detailArray {

                            self.coreDataManager.saveFavorite(name: detailArr.name ?? "", released: detailArr.released ?? "", rating: detailArr.rating ?? 0.0 , attDescription: detailArr.description ?? "" , background_image: detailArr.background_image ?? "",isSelected: false,id: Int(detailArr.id ?? 0 ))
                            
                            self.onUpdateArray(detailArr)
                            
                        }
                    case.failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    func touchLiked(id:Int) -> Bool{
        guard let gameDetail = coreDataManager.getFavorite(id) else{return false}
        gameDetail.isSelected = !gameDetail.isSelected
        
        if gameDetail.isSelected {
            coreDataManager.updateFavorite(event: gameDetail, name: gameDetail.name ?? "", released: gameDetail.released ?? "", rating: gameDetail.rating , background_image: gameDetail.background_image ?? "", isSelected: gameDetail.isSelected , attDescription: gameDetail.attDescription ?? "" ,id: Int(gameDetail.id ))
            
        }else{
            coreDataManager.updateFavorite(event: gameDetail, name: gameDetail.name ?? "", released: gameDetail.released ?? "", rating: gameDetail.rating , background_image: gameDetail.background_image ?? "", isSelected: gameDetail.isSelected , attDescription: gameDetail.attDescription ?? "" ,id: Int(gameDetail.id ))
        }
        
        return gameDetail.isSelected
    }
}
