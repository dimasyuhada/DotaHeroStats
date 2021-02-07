//
//  Hero+CoreDataProperties.swift
//  HeroStats
//
//  Created by macuser on 07/02/2021.
//  Copyright © 2021 Dimas Syuhada. All rights reserved.
//
//

import Foundation
import CoreData


extension Hero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hero> {
        return NSFetchRequest<Hero>(entityName: "Hero")
    }

    @NSManaged public var attack_type: String?
    @NSManaged public var primary_attr: String?
    @NSManaged public var base_health: Int32
    @NSManaged public var base_mana: Int32
    @NSManaged public var localized_name: String?
    @NSManaged public var roles: [String]?
    @NSManaged public var move_speed: Int32
    @NSManaged public var id: Int32
    @NSManaged public var img: String?
    @NSManaged public var base_attack_max: Int32

}

extension Hero : Identifiable {

}
