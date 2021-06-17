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
    var pageImageArray: [Results] = []

    var onUpdate = {}
    var onSearchTextIsEmpty = {}
    var onSearchTextControl: (_ status:Bool?) -> Void = {_ in}
        
    func fetchData(){
        DispatchQueue.main.async {
            //self.coreDataManager.deleteGameList()
            
            if self.coreDataManager.fetchGameList() != nil && self.coreDataManager.fetchGameList() != []{
                if let gameList = self.coreDataManager.fetchGameList(){
                    print(gameList)
                    self.resultArray = gameList.compactMap{
                        Results(name: $0.name ?? "", id: Int($0.id), rating: $0.rating, slug: "", background_image: $0.background_image ?? "", released: $0.released ?? "")
                    }
                    self.pageImageArray = Array(self.resultArray[0 ..< 3])
                    self.filteredArray = self.resultArray
                    self.onUpdate()
                }
            }else {
                APIService.shared.getGameList { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case.success(let games):
                        self.resultArray = games.results
                        self.filteredArray = self.resultArray
                        self.pageImageArray = Array(self.resultArray[0 ..< 3])
                        for filteredItem in self.filteredArray {
                            self.coreDataManager.saveGameList(name: filteredItem.name, released: filteredItem.released, rating: filteredItem.rating, background_image: filteredItem.background_image,id: filteredItem.id)
                        }
                        self.onUpdate()
                    }
                }
                
            }
            
        }
    }
    
    func viewControllerBefore(pages:[UIViewController],viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {return nil}
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
        
    }
    
    func viewControllerAfter(pages:[UIViewController],viewController: UIViewController) -> UIViewController?{
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil}
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
            self.filteredArray = Array(self.resultArray[3...])
            onSearchTextIsEmpty()
            return
        }
        if searchText.count > 3 {
            self.filteredArray = self.resultArray.filter({ game -> Bool in
                game.name.contains(searchText)
            })
            if self.filteredArray == [] {
                onSearchTextControl(true)
            }else{
                onSearchTextControl(false)
            }
        }
        
    }
}






