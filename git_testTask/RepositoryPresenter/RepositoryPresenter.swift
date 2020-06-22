//
//  RepositoryPresenter.swift
//  GitHub_testTask
//
//  Created by Sasha Myshkina on 21.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class RepositoryPresenter: NSObject, RepositoryPresenterProtocol {

    weak var allRepositoriesView: AllRepositoriesView?
    weak var detailedRepositoryView: DetailedRepositoryView?
    
    var search: Search!
    
    var repos: [Repository] {
        return RepositoryDataManager.shared.fetchAllRepositories()
    }
    
    var chosenRepo: Repository?
    

    func attachView(view: AllRepositoriesView) {
        allRepositoriesView = view
    }
    
    func loadMore() {
        guard let search = search, !search.ended else {
            return
        }
        
        search.currentPage += 1
        allRepositoriesView?.showProgressHud()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            RepositoryDataManager.shared.getRepositories(by: search.searchString, page: Int(search.currentPage))
            let result = RepositoryDataManager.shared.fetchAllRepositories()
            DispatchQueue.main.async {
                self.reload(with: result)
                self.allRepositoriesView?.hideProgressHud()
            }
        }
    }
    

    func tapOnCell(with indexPath: IndexPath) {
        chosenRepo = repos[indexPath.item]
        guard let repositoryForDetailedVC = chosenRepo else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        detailedRepositoryView = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        allRepositoriesView?.open(detailedView: detailedRepositoryView as! DetailViewController)
        detailedRepositoryView?.setView(with: repositoryForDetailedVC)
    }
    
    func searchFor(repo: String) {
        RepositoryDataManager.shared.removeAll()
        search = RepositoryDataManager.shared.getSearch(for: repo)
        search.currentPage = 1
        
        allRepositoriesView?.showProgressHud()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            RepositoryDataManager.shared.getRepositories(by: self.search.searchString, page: Int(self.search.currentPage))
            let result = RepositoryDataManager.shared.fetchAllRepositories()
            DispatchQueue.main.async {
                self.reload(with: result)
                self.allRepositoriesView?.scrollToTop()
                self.allRepositoriesView?.hideProgressHud()
            }
        }
    }
    
    func reload(with result: [Repository])  {
        allRepositoriesView?.reload()
    }
    
    func setupUI() {
        search = RepositoryDataManager.shared.getSearch()
        self.reload(with: RepositoryDataManager.shared.fetchAllRepositories())
        allRepositoriesView?.setLastSearch(text: search.searchString)
    }
    
    func getFormattedDate(from string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: string)!
        formatter.dateFormat = "MMM d, yyyy, HH:mm"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func provideImageForRepo(repo: Repository) -> UIImage {
        if let data = repo.owner.image, let image = UIImage(data: data) {
            return image
        } else {
            guard let image = RepositoryAPIClient.shared.getImage(with: repo.owner.avatarURL) else {
                return UIImage(named: K.noUserImage)!
            }
            
            return image
        }
    }
}


