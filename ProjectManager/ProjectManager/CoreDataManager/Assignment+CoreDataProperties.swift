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
  func convertProject() -> Project? {
    guard let title = self.title,
          let body = self.body,
          let id = self.id,
          let deadLineDate = self.deadLineDate else {
      return nil
    }
    
    return Project(id: id, title: title, date: deadLineDate, description: body, state: .todo)
  }
}
