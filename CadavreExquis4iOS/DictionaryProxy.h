//
//  DictionarProxy.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden*. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
- (NSManagedObject*) selectById:(NSString*) entity byId:(int)objectId;
- (NSManagedObject*) select:(NSString*)entity withType:(int)type isRandom:(BOOL)random withLimit:(int)limit ascending:(BOOL)ascending;
- (NSManagedObject*) newEntity:(NSString*) name;
- (void) remove:(NSManagedObject*)entity;
@end
