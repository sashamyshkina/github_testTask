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

    @NSManaged public var fullName: NSObject?
    @NSManaged public var updated_at: NSObject?
    @NSManaged public var htmlURL: NSObject?
    @NSManaged public var descriptionText: NSObject?
    @NSManaged public var language: NSObject?
    @NSManaged public var owner: Owner?

}
