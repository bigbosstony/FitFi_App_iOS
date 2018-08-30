//
//  Schedule+CoreDataProperties.swift
//  
//
//  Created by Harsh_Dev on 23/08/18.
//
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var monday: Bool
    @NSManaged public var date: NSDate?
    @NSManaged public var saturday: Bool
    @NSManaged public var tuesday: Bool
    @NSManaged public var friday: Bool
    @NSManaged public var wednesday: Bool
    @NSManaged public var thursday: Bool
    @NSManaged public var sunday: Bool
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
