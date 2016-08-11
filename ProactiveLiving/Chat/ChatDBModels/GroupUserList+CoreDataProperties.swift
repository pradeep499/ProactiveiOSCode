//
//  GroupUserList+CoreDataProperties.swift
//  Five Dots
//
//  Created by Ankur Batham on 7/4/16.
//  Copyright © 2016 Appstudioz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension GroupUserList {

    @NSManaged var groupId: String?
    @NSManaged var isAdmin: String?
    @NSManaged var isDeletedGroup: String?
    @NSManaged var isNameAvail: String?
    @NSManaged var loginUserId: String?
    @NSManaged var userId: String?
    @NSManaged var userImage: String?
    @NSManaged var userName: String?

}
