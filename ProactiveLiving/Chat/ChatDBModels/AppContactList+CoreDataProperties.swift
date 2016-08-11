//
//  AppContactList+CoreDataProperties.swift
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

extension AppContactList {

    @NSManaged var email: String?
    @NSManaged var isBlock: String?
    @NSManaged var isFav: String?
    @NSManaged var isFriend: String?
    @NSManaged var isFromCont: String?
    @NSManaged var isFromFB: String?
    @NSManaged var isReport: String?
    @NSManaged var loginUserId: String?
    @NSManaged var name: String?
    @NSManaged var phoneName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var recordId: String?
    @NSManaged var updateDate: String?
    @NSManaged var userId: String?
    @NSManaged var userImgString: String?

}
