//
//  FavoriteGameViewModel.swift
//  RAWGames
//
//  Created by ahmet on 17.06.2021.
//

import Foundation

class FavoriteGameViewModel{
    
    let coreDataManager: CoreDataManager = CoreDataManager()
    var games: [FavoriteGame] = []

    func fetchFavoriteGame(){
        
        let gameList = coreDataManager.fetchFavorites()
        
        games = gameList.filter({ game in
            game.isSelected == true
        })

    }
    
    func updateFavoriteGame(favoriteGame:FavoriteGame){
        self.coreDataManager.updateFavorite(event: favoriteGame, name: favoriteGame.name ?? "", released: favoriteGame.released ?? "", rating: favoriteGame.rating , background_image: favoriteGame.background_image ?? "", isSelected: false , attDescription: favoriteGame.attDescription ?? "" ,id: Int(favoriteGame.id ))
    }
    
}
