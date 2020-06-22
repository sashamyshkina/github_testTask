//
//  Repository+CoreDataProperties.swift
//  git_testTask
//
//  Created by Sasha Myshkina on 21.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//
//

import Foundation
import CoreData


extension Repository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repository> {
        return NSFetchRequest<Repository>(entityName: "Repository")
    }

    @NSManaged public var fullName: String
    @NSManaged public var updated_at: String
    @NSManaged public var htmlURL: String
    @NSManaged public var descriptionText: String?
    @NSManaged public var language: String?
    @NSManaged public var owner: Owner
    @NSManaged public var stargazersCount: Int

}
