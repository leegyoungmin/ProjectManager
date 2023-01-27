//
//  AssignmentLog+CoreDataProperties.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.
        
//

import Foundation
import CoreData


extension AssignmentLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssignmentLog> {
        return NSFetchRequest<AssignmentLog>(entityName: "AssignmentLog")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var assignment: NSSet?

}

// MARK: Generated accessors for assignment
extension AssignmentLog {

    @objc(addAssignmentObject:)
    @NSManaged public func addToAssignment(_ value: Assignment)

    @objc(removeAssignmentObject:)
    @NSManaged public func removeFromAssignment(_ value: Assignment)

    @objc(addAssignment:)
    @NSManaged public func addToAssignment(_ values: NSSet)

    @objc(removeAssignment:)
    @NSManaged public func removeFromAssignment(_ values: NSSet)

}

extension AssignmentLog : Identifiable {

}
