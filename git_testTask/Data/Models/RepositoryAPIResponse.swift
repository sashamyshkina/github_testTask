//
//  Repository.swift
//  GitHub_testTask
//
//  Created by Sasha Myshkina on 18.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit
import CoreData

struct RepositoryAPIResponse: Codable {

    var full_name: String
    var html_url: String
    var owner: OwnerAPIResponse
    var description: String?
    var language: String?
    var updated_at: String
    var stargazers_count: Int
}

struct OwnerAPIResponse: Codable {
    var avatar_url: String?
}

struct SearchResult: Codable {
    var items: [RepositoryAPIResponse]
}
