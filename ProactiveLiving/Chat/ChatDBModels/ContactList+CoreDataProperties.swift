//
//  ContactList+CoreDataProperties.swift
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

extension ContactList {

    @NSManaged var email: String?
    @NSManaged var email1: String?
    @NSManaged var email2: String?
    @NSManaged var email3: String?
    @NSManaged var isDelete: String?
    @NSManaged var isRegistered: String?
    @NSManaged var isUpdatedData: NSNumber?
    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var phoneNumber1: String?
    @NSManaged var phoneNumber2: String?
    @NSManaged var phoneNumber3: String?
    @NSManaged var recordId: String?
    @NSManaged var updateDate: NSDate?
    @NSManaged var userImgString: String?

}
