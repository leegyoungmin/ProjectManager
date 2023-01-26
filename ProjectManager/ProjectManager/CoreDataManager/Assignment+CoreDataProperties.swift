//
//  Assignment+CoreDataProperties.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.
        
//

import Foundation
import CoreData


extension Assignment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignment> {
        return NSFetchRequest<Assignment>(entityName: "Assignment")
    }

    @NSManaged public var body: String?
    @NSManaged public var deadLineDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var log: AssignmentLog?

}

extension Assignment : Identifiable {

}
