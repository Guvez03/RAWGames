//
//  APIService.swift
//  AppCentProject
//
//  Created by ahmet on 10.06.2021.
//

import UIKit
import Alamofire

struct Constant {
    static let baseUrl = "https://api.rawg.io/api/games"
    static let apiKey = "411c3cf2ae7742b8bac619ce2117b197"
}

class APIService {
    
    static let shared = APIService()
    
    func getGameList(completionHandler: @escaping (Result<GameModels,Error>) -> Void) {
        getGames(completionHandler)
    }
    
    func getFavoriteGames(_ id: Int, completionHandler: @escaping (Result<GameDetailModel,Error>) -> Void) {
        getFavorite(id, completion: completionHandler)
    }
    
    func getGames(_ completion: @escaping (Result<GameModels,Error>) -> Void){
        
        guard let urlString =  URL(string: Constant.baseUrl + "?key=" + Constant.apiKey) else {
            return
        }
        print(urlString)
        
        AF.request(urlString,method: .get)
            .responseJSON { response in                
                switch response.result {
                case .success( _):
                    guard let data = response.data else {return}
                    do{
                        let games = try JSONDecoder().decode(GameModels.self, from: data)
                        completion(.success(games))
                    }catch{
                        print("Error decoding = \(error)")
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
    
    func getFavorite(_ id:Int,completion: @escaping (Result<GameDetailModel,Error>) -> Void){
        
        guard let urlString =  URL(string: Constant.baseUrl + "/\(id)" + "?key=" + Constant.apiKey) else {
            return
        }
        print(urlString)
        
        AF.request(urlString, method: .get)
            .responseJSON { response in
                
                switch response.result{
                case.success(_):
                    guard let data = response.data else {return}
                    do{
                        let games = try JSONDecoder().decode(GameDetailModel.self, from: data)
                        completion(.success(games))
                        
                    }catch{
                        print("Error decoding = \(error)")
                    }
                    
                case.failure(let error):
                    print("Error favorite game result = \(error)")
                }
            }
    }
    
}




