//
//  ViewController.swift
//  NewsExplorer
//
//  Created by Stanislav Tereshchenko on 03.10.2022.
//

import UIKit

class AllArticlesViewController: UIViewController {
    
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(AllArticleTableViewCell.self,
                       forCellReuseIdentifier: AllArticleTableViewCell.identifier)
        return table
    }()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var articles = [Article]()
    
    private var viewModels = [AllArticlesTableViewCellViewModel]()
    
    let spacingBetweenCells = 100.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        customNavigationBar()
        createSearchBar()
        fetchAllNews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 80, width: view.frame.width, height: view.frame.height)
    }
    
    private func customNavigationBar() {
        
        navigationController?.navigationBar.backgroundColor =
        UIColor(red: 22/255, green: 23/255, blue: 28/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchController
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
        }
        
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = [
            "Top Rated", "Last 3 days", "Last 7 days", "Last 30 days"
        ]
        
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ArticleDetailsViewController
        let article = sender as? Article
        vc.articles = article
        
    }
    
    private func fetchAllNews() {
        
        NetworkManager.shared.getTopNews { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    AllArticlesTableViewCellViewModel(title: $0.title!,
                                                      subtitle: $0.description ?? ""
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchAllNews()
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        NetworkManager.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    AllArticlesTableViewCellViewModel(title: $0.title!,
                                                      subtitle: $0.description ?? ""
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchController.dismiss(animated: true, completion: nil)
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    private func fetchFilteredDays() {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        
        var scopeIndex = searchController.searchBar.selectedScopeButtonIndex
        
        
        switch scopeIndex {
        case 1:
            scopeIndex = 3
        case 2:
            scopeIndex = 7
        case 3:
            scopeIndex = 30
            
        default:
            break
        }
        
        NetworkManager.shared.getFilteredDay(with: text, with: scopeIndex) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    AllArticlesTableViewCellViewModel(title: $0.title ?? "",
                                                      subtitle: $0.description ?? ""
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchController.dismiss(animated: true, completion: nil)
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}



extension AllArticlesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.row]
        performSegue(withIdentifier: "ArticleDetailsViewControllerIdn", sender: selectedArticle)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red: 60/255, green: 70/255, blue: 77/255, alpha: 1)
        cell.selectionStyle = .none
        cell.layer.borderWidth = 2.0
        
        
    }
}

extension AllArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModels.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllArticleTableViewCell.identifier,
                                                       for: indexPath
        ) as? AllArticleTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension AllArticlesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            fetchAllNews()
            print("Index \(selectedScope)")
        case 1:
            fetchFilteredDays()
            
            print("Index \(selectedScope)")
        case 2:
            fetchFilteredDays()
            print("Index \(selectedScope)")
        case 3:
            fetchFilteredDays()
            print("Index \(selectedScope)")
            
        default:
            break
        }
        
        
        
    }
}
