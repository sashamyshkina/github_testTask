//
//  RepositoryCellCollectionViewCell.swift
//  GitHub_testTask
//
//  Created by Sasha Myshkina on 19.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit

class RepositoryCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    
    var downloadTask: URLSessionDataTask!
    
    var repository: Repository!
    
    //that's a weak spot, but I haven't come up with a better idea yet
    var imageURL: String? {
        didSet {
            if oldValue != imageURL {
                ownerImageView.image = UIImage(named: K.noUserImage)
                downloadTask?.cancel()
                
                if let imageData = self.repository.owner.image {
                    self.ownerImageView.image = UIImage(data: imageData)
                } else {
                    if let urlString = imageURL, let url = URL(string: urlString) {
                        downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if let data = data {
                                DispatchQueue.main.async {
                                    self.ownerImageView.image = UIImage(data: data)
                                    if !self.repository.isDeleted && !self.repository.owner.isDeleted {
                                        self.repository.owner.image = data
                                        RepositoryDataManager.shared.saveContext()
                                    }
                                }
                            }
                        })
                        downloadTask.resume()
                    }
                }
                
            }
        }
    }
    
    public func configure(with model: Repository) {
        repository = model
        repoNameLabel.text = model.fullName
        imageURL = model.owner.avatarURL
    }

    
    
}
