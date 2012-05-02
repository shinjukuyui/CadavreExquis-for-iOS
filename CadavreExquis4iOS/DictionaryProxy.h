//
//  Dictionary.h
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/03/13.
//  Copyright (c) 2012年 Tragile Eden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DictionaryProxy : NSObject {
    NSManagedObjectContext* context;
    NSManagedObjectModel* model;
    NSPersistentStoreCoordinator* coordinator;
}
@property (nonatomic, strong, readonly) NSManagedObjectContext* context;
@property (nonatomic, strong, readonly) NSManagedObjectModel* model;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* coordinator;
+ (DictionaryProxy*) sharedInstance;
- (NSURL*) applicationDocumentsDirectory;
- (void) initializeData;
- (void) save;
- (NSUInteger) counts:(NSString*)entity withType:(int)type;
- (NSMutableArray*) selectAll:(NSString*)entity withType:(int)type ascending:(BOOL)ascending;
- (NSMutableArray*) selectAt:(NSString*)entity withType:(int)type ascending:(BOOL)ascending indexOf:(int)index;
- (NSManagedObject*) select:(NSString*)entity withType:(int)type isRandom:(BOOL)random withLimit:(int)limit ascending:(BOOL)ascending;
- (NSManagedObject*) newEntity:(NSString*) name;
- (void) remove:(NSManagedObject*)entity;
@end
