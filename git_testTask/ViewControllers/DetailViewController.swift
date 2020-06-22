//
//  DetailViewController.swift
//  GitHub_testTask
//
//  Created by Sasha Myshkina on 20.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailedRepositoryView {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var LanguageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var presenter: RepositoryPresenterProtocol!
    var repo: Repository?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RepositoryPresenter()
        
        guard let repository = repo else {
            return
        }
        configureUI(repoName: repository.fullName, ownerImage: presenter.provideImageForRepo(repo: repository), dateUpdated: repository.updated_at, language: repository.language, description: repository.descriptionText)
    }
    
    @IBAction func seeMoreButtonTapped(_ sender: Any) {
        guard let repository = repo, let url = URL(string: repository.htmlURL) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    
    func configureUI(repoName: String, ownerImage: UIImage?, dateUpdated: String, language: String?, description: String?) {
        authorImageView.image = ownerImage
        repoNameLabel.text = repoName
        updatedAtLabel.text = dateUpdated
        descriptionLabel.text = description ?? ""
        LanguageLabel.text = language ?? K.noLanguage
    }
    
    func setView(with repository: Repository) {
        repo = repository
    }
}


protocol DetailedRepositoryView: class {
    var presenter: RepositoryPresenterProtocol! { get set }
    func setView(with repository: Repository)
}
