//
//  GameListViewModel.swift
//  AppCentProject
//
//  Created by ahmet on 14.06.2021.
//

import UIKit


class GameListViewModel{
    
    let coreDataManager: CoreDataManager = CoreDataManager()
    var resultArray: [Results] = []
    var filteredArray: [Results] = []
    
    var onUpdate: ([Results]) -> Void = {_ in}
    var onSearchTextIsEmpty = {}
    var onSearchTextControl = {}
    
    func fetchData(){
        DispatchQueue.main.async {
            
            //self.coreDataManager.deleteGameList()
            
            if self.coreDataManager.fetchGameList() != nil && self.coreDataManager.fetchGameList() != []{
                if let gameList = self.coreDataManager.fetchGameList(){
                    print(gameList)
                    self.resultArray = gameList.compactMap{
                        Results(name: $0.name ?? "", id: Int($0.id), rating: $0.rating, slug: "", background_image: $0.background_image ?? "", released: $0.released ?? "")
                    }
                    self.onUpdate(self.resultArray)
                }
            }else {
                APIService.shared.getGameList { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case.success(let games):
                        self.resultArray = games.results
                        self.filteredArray = self.resultArray
                        for filteredItem in self.filteredArray {
                            self.coreDataManager.saveGameList(name: filteredItem.name, released: filteredItem.released, rating: filteredItem.rating, background_image: filteredItem.background_image,id: filteredItem.id)
                        }
                        self.onUpdate(self.resultArray)
                    }
                }
                
            }
            
        }
    }
    
    
    func viewControllerBefore(pages:[UIViewController],viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {return nil}
        
        print("previous : \(viewControllerIndex)")
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return pages.last }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
        
    }
    
    func viewControllerAfter(pages:[UIViewController],viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil}
        
        print("next : \(viewControllerIndex)")
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
        
    }
    func presentationCount(pages:[UIViewController]) -> Int {
        return pages.count
    }
    func presentationIndex(for pageViewController: UIPageViewController,pages:[UIViewController]) -> Int {
        
        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }
        
        return firstVCIndex
    }
    func searchTextdidChange(searchText:String) {
        
        guard !searchText.isEmpty else{
            onSearchTextIsEmpty()
            return
        }
        if searchText.count > 3 {
            onSearchTextControl()
        }
        
    }
}






