//
//  RepositoryPresenterProtocol.swift
//  GitHub_testTask
//
//  Created by Sasha Myshkina on 18.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit
import CoreData


protocol RepositoryPresenterProtocol: class {
    
    var repos: [Repository] { get }
    
    var chosenRepo: Repository? { get set }
    
    func attachView(view: AllRepositoriesView)
    
    func searchFor(repo: String)
    
    func tapOnCell(with indexPath: IndexPath)
    
    func provideImageForRepo(repo: Repository) -> UIImage
    
    func loadMore()
    
    func setupUI()
    
}



