//
//  Entity+CoreDataProperties.swift
//  Feedmin
//
//  Created by 戸上　祐希 on 2018/06/13.
//  Copyright © 2018年 Togami Yuki. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var siteURL: String?
    @NSManaged public var siteTitle: String?

}
