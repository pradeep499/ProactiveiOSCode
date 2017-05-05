   

#import "StrorePhoneContact.h"
#import <UIKit/UIKit.h>
#import "ProactiveLiving-Swift.h"


@implementation StrorePhoneContact
@synthesize allNewContactsRecordeIds;
@synthesize isContactsChanged;

+(StrorePhoneContact *) sharedStrorePhoneContact
{
    static StrorePhoneContact *singletone;
    if(!singletone)
    {
        singletone=[[StrorePhoneContact alloc] init];
    }
   
    return singletone;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        self.isContactsChanged=YES;
        self.allNewContactsRecordeIds=[[NSMutableArray alloc] init];
        self.allNewPhoneNumbers=[NSMutableArray array];
        
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
     ////NSLog(@"ontime value :::: %@",[userDefaults objectForKey:@"oneTime"]);

    //Commented-31
    if (![userDefaults objectForKey:@"oneTime"])
    {
        //Ankur
//        ////NSLog(@"inside notification");
//        CFErrorRef *error = NULL;
//        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
//        ABAddressBookUnregisterExternalChangeCallback(addressBook, externalChangeCallback, (__bridge void *)(self));
//        ABAddressBookRegisterExternalChangeCallback(addressBook, externalChangeCallback, (__bridge void *)(self));
//        [userDefaults setObject:@"1" forKey:@"oneTime"];
    }
    
    
    return self;
}
// somewhere else in the MyAddressBook class:
void externalChangeCallback(ABAddressBookRef reference, CFDictionaryRef info, void *context)
{
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:@"ContactChanged"];
    //[userDefaults setObject:@"" forKey:@"ContactChanged"];
    if (![userDefaults objectForKey:@"oneTimePostNotification"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotPhone" object:nil];
        [userDefaults setObject:@"1" forKey:@"oneTimePostNotification"];
         ////NSLog(@"post notification changed:::::::::::::::");
        
    }
    

}



void addressBookChanged(ABAddressBookRef abRef, CFDictionaryRef dicRef, void *context)
{
    [(__bridge id)context reloadContactDetails];
    ABAddressBookUnregisterExternalChangeCallback(abRef, addressBookChanged, context);
}

-(void) reloadContactDetails
{
    self.isContactsChanged=YES;
}


#pragma mark - Indexing tableMethod

-(NSMutableDictionary *)createDictionaryForSectionIndex:(NSMutableArray *)array
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    ////NSLog(@"Array Values: %@",array);
    
    for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
    {
        //NSPredicates are fast
        NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
        NSArray *content = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name beginswith[cd] %@", firstCharacter]];
        NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:content];
        
        if ([mutableContent count] > 0)
        {
            NSString *key = [firstCharacter uppercaseString];
            [dict setObject:mutableContent forKey:key];
        }
    }
    return dict;
}
-(NSMutableDictionary *)createDictionaryForPhoneSectionIndex:(NSMutableArray *)array
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
    {
        //NSPredicates are fast
        NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
        NSArray *content = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name beginswith[cd] %@", firstCharacter]];
        NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:content];
        
        if ([mutableContent count] > 0)
        {
            NSString *key = [firstCharacter uppercaseString];
            [dict setObject:mutableContent forKey:key];
        }
    }
    NSArray *content = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name beginswith[cd] %@ OR name beginswith[cd] %@  OR name beginswith[cd] %@ OR name beginswith[cd] %@ OR name beginswith[cd] %@ OR name beginswith[cd] %@ OR name beginswith[cd] %@ OR name beginswith[cd] %@ OR name beginswith[cd] %@ OR name beginswith[cd] %@ OR name beginswith[cd] %@",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"("]];
//     NSArray *content = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name beginswith[cd] %@,@"9"]];
    ////NSLog(@"%@",content);
    NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:content];
    
    if ([mutableContent count] > 0)
    {
        NSString *key = @"#";
        [dict setObject:mutableContent forKey:key];
    }
    return dict;
}
-(NSMutableDictionary *)createDictionaryFbForSectionIndex:(NSMutableArray *)array
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
    {
        //NSPredicates are fast
        NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
        NSArray *content = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phoneName beginswith[cd] %@", firstCharacter]];
        NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:content];
        
        if ([mutableContent count] > 0)
        {
            NSString *key = [firstCharacter uppercaseString];
            [dict setObject:mutableContent forKey:key];
        }
    }
    return dict;
}
-(NSMutableDictionary *)createDictionaryFavForSectionIndex:(NSMutableArray *)array
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
    {
        //NSPredicates are fast
        NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
        NSMutableArray *mutableContent=[NSMutableArray array];
        //NSArray *content = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"phoneName beginswith[cd] %@", firstCharacter]];
        for (AppContactList *obj in array)
        {
            if ([obj.isFromFB isEqualToString:@"1"])
            {
                if (tolower([obj.phoneName characterAtIndex:0]) == firstChar)
                {
                    [mutableContent addObject:obj];
                }
            }else
            {
                if (tolower([obj.name characterAtIndex:0]) == firstChar)
                {
                    [mutableContent addObject:obj];
                }
            }
        }
       // NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:content];
        
        if ([mutableContent count] > 0)
        {
            NSString *key = [firstCharacter uppercaseString];
            [dict setObject:mutableContent forKey:key];
        }
    }
    return dict;
}
@end
