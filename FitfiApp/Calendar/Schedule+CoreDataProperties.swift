//
//  Schedule+CoreDataProperties.swift
//  
//
//  Created by Harsh_Dev on 13/08/18.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var dayOfWeek: String?
    @NSManaged public var schdule: NSSet?

}

// MARK: Generated accessors for schdule
extension Schedule {

    @objc(addSchduleObject:)
    @NSManaged public func addToSchdule(_ value: Routine)

    @objc(removeSchduleObject:)
    @NSManaged public func removeFromSchdule(_ value: Routine)

    @objc(addSchdule:)
    @NSManaged public func addToSchdule(_ values: NSSet)

    @objc(removeSchdule:)
    @NSManaged public func removeFromSchdule(_ values: NSSet)

}
