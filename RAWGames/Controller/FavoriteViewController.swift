//
//  FavoriteViewController.swift
//  AppCentProject
//
//  Created by ahmet on 9.06.2021.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    var favoriteGameViewModel = FavoriteGameViewModel()
        
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    override func viewWillAppear(_ animated: Bool) {

        favoriteGameViewModel.fetchFavoriteGame()
        tableView.reloadData()
    }

    func setupView(){
        
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
}
extension FavoriteViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGameViewModel.games.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.cellId, for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        
        let favoriteGame = favoriteGameViewModel.games[indexPath.row]
        cell.favoriteGameViewModel = favoriteGameViewModel
        cell.configure(index: indexPath.row)

        cell.onUpdate = {
            self.favoriteGameViewModel.updateFavoriteGame(favoriteGame: favoriteGame)
            
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.tableView.beginUpdates()
                self.favoriteGameViewModel.games.remove(at: indexPath.row)
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
