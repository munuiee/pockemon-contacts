//
//  Entity+CoreDataProperties.swift
//  pokeContact
//
//  Created by Jihye의 MacBook Pro on 9/29/25.
//
//

import Foundation
import CoreData


extension Information {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Information> {
        return NSFetchRequest<Information>(entityName: "Information")
    }

    @NSManaged public var name: String?
    @NSManaged public var contact: String?
    @NSManaged public var imageURL: String?

}

extension Information : Identifiable {

}
