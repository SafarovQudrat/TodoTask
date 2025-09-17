//
//  UsersCD+CoreDataProperties.swift
//  TodoTask
//
//  Created by Safarov Qudrat  on 17/09/25.
//
//

public import Foundation
public import CoreData


public typealias UsersCDCoreDataPropertiesSet = NSSet

extension UsersCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersCD> {
        return NSFetchRequest<UsersCD>(entityName: "UsersCD")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var username: String?
    @NSManaged public var website: String?

}

extension UsersCD : Identifiable {

}
