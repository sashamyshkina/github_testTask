//
//  RepositoryDataManager.swift
//  GitHub_testTask
//
//  Created by Sasha Myshkina on 21.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit
import CoreData


class RepositoryDataManager {
    
    private init() {}
    
    static let shared = RepositoryDataManager()
    
    func getSearch(for search: String = "") -> Search {
        let fetch = NSFetchRequest<Search>(entityName: "Search")
        let searches = (try? context.fetch(fetch)) ?? []
        if let s = searches.first {
            return s
        }
        let s = Search(context: context)
        s.searchString = search
        s.ended = false
        return s
    }
    
    func setSearchEnded() {
        let search = getSearch()
        search.ended = true
    }
    
    
    func getRepositories(by repoName: String, page: Int) {
        let result = RepositoryAPIClient.shared.getRepositories(by: repoName, page: page)

        var repoResults: [RepositoryAPIResponse] = []
        
        switch result {
        case .failure(_):
            setSearchEnded()
        case let .success(searchResult):
            repoResults = searchResult?.items ?? []
        case .none:
            return
        }

        
        for repo in repoResults {
            let r = Repository(context: context)
            r.fullName = repo.full_name
            r.htmlURL = repo.html_url
            r.language = repo.language
            r.descriptionText = repo.description
            r.updated_at = repo.updated_at
            r.stargazersCount = repo.stargazers_count
            
            let owner = Owner(context: context)
            owner.avatarURL = repo.owner.avatar_url
            
            r.owner = owner
        }
        
        saveContext()
    }
    
    func fetchAllRepositories() -> [Repository] {
        let fetch = NSFetchRequest<Repository>(entityName: "Repository")
        fetch.sortDescriptors = [NSSortDescriptor(key: "stargazersCount", ascending: false)]
        return (try? context.fetch(fetch)) ?? []
    }
    
    
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "git_testTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        DispatchQueue.main.async {
            let context = self.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func removeAll() {
        let fetchRepositories = NSFetchRequest<NSFetchRequestResult>(entityName: "Repository")
        let batchDeleteRepositories = NSBatchDeleteRequest(fetchRequest: fetchRepositories)
        _ = try? context.execute(batchDeleteRepositories)

        let fetchOweners = NSFetchRequest<NSFetchRequestResult>(entityName: "Owner")
        let batchDeleteOwners = NSBatchDeleteRequest(fetchRequest: fetchOweners)
        _ = try? context.execute(batchDeleteOwners)

        let fetchSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "Search")
        let batchDeleteSearches = NSBatchDeleteRequest(fetchRequest: fetchSearch)
        _ = try? context.execute(batchDeleteSearches)

        saveContext()
    }
}
