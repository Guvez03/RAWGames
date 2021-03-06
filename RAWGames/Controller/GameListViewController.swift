//
//  TestViewController.swift
//  AppCentProject
//
//  Created by ahmet on 9.06.2021.
//

import UIKit
import Alamofire
import Kingfisher

class GameListViewController: UIViewController{
    
    var vc : ViewController?
    var pages: [UIViewController] = [UIViewController]()
    var pageView =  UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var count = 0

    let myContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()

    let noticeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "Üzgünüz, aradığınız oyun bulunamadı!"
        label.backgroundColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    let searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.showsCancelButton = false
        searchbar.sizeToFit()
        searchbar.placeholder = "Aranacak Kelime"
        return searchbar
    }()

    let gameListViewModel = GameListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        fetchData()
        
        gameListViewModel.onUpdate = {  
            self.pageViewSetUp()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false

    }

    func fetchData(){
        gameListViewModel.fetchData()
    }
    
    func pageViewSetUp(){
        let array = gameListViewModel.pageImageArray
        for i in 0 ..< array.count {
            let vc = ViewController()
            vc.imageName = array[i].background_image
            vc.imageBtn.addTarget(self, action: #selector(self.imgBtnTouched), for: .touchUpInside)
            vc.imageBtn.tag = i
            self.pages.append(vc)
        }
        self.gameListViewModel.filteredArray[0 ..< 3].removeAll()
        self.pageView.setViewControllers([self.pages[0]], direction: .forward, animated: false, completion: nil)
        self.tableView.reloadData()
    }
    
    @objc func imgBtnTouched(_ sender: UIButton){
        let tag = sender.tag
        let selectedImage = self.gameListViewModel.pageImageArray[tag]
        let detailVC = DetailViewController()
        detailVC.id = selectedImage.id
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func setUpView(){
        
        view.backgroundColor = .white
        
        pageView.dataSource = self
        pageView.delegate = nil
        searchBar.delegate = self
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .white
        
        view.addSubview(noticeLabel)
        noticeLabel.isHidden = true
        noticeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noticeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5).isActive = true
        
        tableView.register(GamesTableViewCell.self, forCellReuseIdentifier: GamesTableViewCell.cellId)
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = searchBar
                
        view.addSubview(myContainerView)
        NSLayoutConstraint.activate([
            myContainerView.topAnchor.constraint(equalTo: view.topAnchor,constant: 15),
            myContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            myContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            myContainerView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.frame = CGRect(x: 15, y: view.frame.height / 3, width: view.frame.width - 30, height: view.frame.height - view.frame.height / 3)
        
        addChild(pageView)
        pageView.view.backgroundColor = .white
        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        myContainerView.addSubview(pageView.view)
        NSLayoutConstraint.activate([
            pageView.view.topAnchor.constraint(equalTo: myContainerView.topAnchor),
            pageView.view.trailingAnchor.constraint(equalTo: myContainerView.trailingAnchor),
            pageView.view.leadingAnchor.constraint(equalTo: myContainerView.leadingAnchor),
            pageView.view.heightAnchor.constraint(equalTo: myContainerView.heightAnchor)
        ])
        pageView.didMove(toParent: self)
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.clear
        
    }
    
    @objc func handleShowSearchBar(){
        
    }
    
}

extension GameListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.gameListViewModel.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GamesTableViewCell.cellId, for: indexPath) as? GamesTableViewCell else { return UITableViewCell() }
        
        cell.gameListViewModel = gameListViewModel
        cell.configureCell(indexpath: indexPath.row)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = self.gameListViewModel.filteredArray[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.id = selected.id
        self.present(detailVC, animated: true, completion: nil)
    }
}


extension GameListViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return gameListViewModel.viewControllerBefore(pages:pages,viewController:viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return gameListViewModel.viewControllerAfter(pages: pages, viewController: viewController)
    }
    
}
extension GameListViewController: UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return gameListViewModel.presentationCount(pages:pages)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return gameListViewModel.presentationIndex(for:pageViewController,pages:pages)
    }
}

extension GameListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        gameListViewModel.searchTextdidChange(searchText: searchText)
        
        gameListViewModel.onSearchTextIsEmpty = {
            self.pageView.view.isHidden = false
            self.vc?.view.isHidden = false
            self.noticeLabel.isHidden = true
            self.tableView.isHidden = false
            self.myContainerView.isHidden = false
            self.tableView.frame = CGRect(x: 15, y: self.pageView.view.frame.height, width: self.view.frame.width - 30, height: self.view.frame.height - self.view.frame.height / 3)
            self.tableView.reloadData()
        }
        
        gameListViewModel.onSearchTextControl =  { (status) in
            self.pageView.view.isHidden = true
            self.vc?.view.isHidden = true
            self.myContainerView.isHidden = true
            self.tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

            switch status {
            case true:
                self.noticeLabel.isHidden = false
                self.tableView.isHidden = true
            case false:
                self.noticeLabel.isHidden = true
                self.tableView.isHidden = false
            default: break
            }
            self.tableView.reloadData()
        }

    }
}

