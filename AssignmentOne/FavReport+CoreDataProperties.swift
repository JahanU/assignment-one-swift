//
//  FavReport+CoreDataProperties.swift
//  AssignmentOne
//
//  Created by Jahan on 10/03/2019.
//  Copyright © 2019 Jahan. All rights reserved.
//
//

import Foundation
import CoreData


extension FavReport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavReport> {
        return NSFetchRequest<FavReport>(entityName: "FavReport")
    }

    @NSManaged public var id: String?
    @NSManaged public var year: String?
    @NSManaged public var title: String?
    @NSManaged public var favourite: Bool

}
