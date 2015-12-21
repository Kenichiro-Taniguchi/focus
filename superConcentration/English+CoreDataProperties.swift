//
//  English+CoreDataProperties.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/05.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension English {

    @NSManaged var category: String?
    @NSManaged var meaning: String?
    @NSManaged var word: String?

}
