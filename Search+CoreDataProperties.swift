//
//  Search+CoreDataProperties.swift
//  git_testTask
//
//  Created by Sasha Myshkina on 21.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var searchString: String
    @NSManaged public var currentPage: Int16
    @NSManaged public var ended: Bool

}
