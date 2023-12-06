//
//  Food+CoreDataProperties.swift
//  MyFoodies
//
//  Created by Aroshini Dissanayake on 2023-06-15.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var place: String?
    @NSManaged public var rating: Double
    @NSManaged public var restaurant: String?
    @NSManaged public var selectedimage: Data?
    @NSManaged public var date: Date?

}

extension Food : Identifiable {

}
