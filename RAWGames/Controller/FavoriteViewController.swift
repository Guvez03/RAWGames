//
//  FavoriteViewController.swift
//  AppCentProject
//
//  Created by ahmet on 9.06.2021.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    let coreDataManager: CoreDataManager = CoreDataManager()
    var games: [FavoriteGame] = []
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.cellId)
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        tableView.frame = view.bounds
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let gameList = coreDataManager.fetchFavorites()
        games = gameList.filter({ game in
            game.isSelected == true
        })
        
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
}
extension FavoriteViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.cellId, for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        
        let index = games[indexPath.row]
        
        cell.gameBackgroundImage.setImage(imageUrl:index.background_image ?? "")
        cell.gameName.text = index.name
        cell.gameRating.text = "\(index.rating) - \(index.released ?? "")"
        cell.likeButton.setBackgroundImage(UIImage(systemName:"hand.thumbsup"), for: .normal)
        index.isSelected ? cell.likeButton.setBackgroundImage(UIImage(systemName:"hand.thumbsup.fill"), for: .normal) :                 cell.likeButton.setBackgroundImage(UIImage(systemName:"hand.thumbsup"), for: .normal)
        
        cell.onUpdate = {
            self.coreDataManager.updateFavorite(event: index, name: index.name ?? "", released: index.released ?? "", rating: index.rating , background_image: index.background_image ?? "", isSelected: false , attDescription: index.attDescription ?? "" ,id: Int(index.id ))
            
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.tableView.beginUpdates()
                self.games.remove(at: indexPath.row)
                let indexPath = IndexPath(item: indexPath.row, section: 0)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
}
