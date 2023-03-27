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
    @NSManaged public var state: Int32
    @NSManaged public var title: String?

}

extension Assignment : Identifiable {
    var projectStatus: ProjectState {
      get {
        return ProjectState(rawValue: Int(state)) ?? .todo
      }
      
      set {
        state = Int32(newValue.rawValue)
      }
    }
    
    
    func convertProject() -> Project {
      guard let title = self.title,
            let body = self.body,
            let id = self.id,
            let deadLineDate = self.deadLineDate else {
        return Project(title: "", date: Date(), description: "")
      }
      
      return Project(id: id, title: title, date: deadLineDate, description: body, state: self.projectStatus)
    }
}
