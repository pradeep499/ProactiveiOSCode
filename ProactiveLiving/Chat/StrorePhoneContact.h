//
//  StrorePhoneContact.h
//  Voicee
//
//  Created by Apple on 23/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface StrorePhoneContact : NSObject
{
    
}
@property(nonatomic) BOOL isContactsChanged;
@property(nonatomic, strong)NSMutableArray *allNewContactsRecordeIds;
@property(nonatomic, strong)NSMutableArray *allNewPhoneNumbers;

+(StrorePhoneContact *) sharedStrorePhoneContact;

-(void) reloadContactDetails;
-(NSMutableDictionary *)createDictionaryForSectionIndex:(NSMutableArray *)array;
-(NSMutableDictionary *)createDictionaryFbForSectionIndex:(NSMutableArray *)array;
-(NSMutableDictionary *)createDictionaryFavForSectionIndex:(NSMutableArray *)array;
-(NSMutableDictionary *)createDictionaryForPhoneSectionIndex:(NSMutableArray *)array;
@end
