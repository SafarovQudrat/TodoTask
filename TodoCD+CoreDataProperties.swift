//
//  TodoCD+CoreDataProperties.swift
//  TodoTask
//
//  Created by Safarov Qudrat  on 17/09/25.
//
//

public import Foundation
public import CoreData


public typealias TodoCDCoreDataPropertiesSet = NSSet

extension TodoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoCD> {
        return NSFetchRequest<TodoCD>(entityName: "TodoCD")
    }

    @NSManaged public var complated: Bool
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var userID: Int64

}

extension TodoCD : Identifiable {

}
