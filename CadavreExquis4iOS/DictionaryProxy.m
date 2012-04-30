//
//  Dictionary.m
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/03/13.
//  Copyright (c) 2012年 Tragile Eden. All rights reserved.
//

#import "DictionaryProxy.h"

@implementation DictionaryProxy
static DictionaryProxy* instance_ = nil;
static dispatch_queue_t serialQueue;
+ (DictionaryProxy*) sharedInstance {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}
+ (id) allocWithZone:(NSZone*) zone {  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("jp.tragile-eden.CadavreExquis.SerialQueue", NULL);        
        if (instance_ == nil) {
            instance_ = [super allocWithZone:zone];
        }
    });
    return instance_; 
}
- (id) copyWithZone:(NSZone*) zone {  
    return self;
}
- (id)init {
    id __block object;
    dispatch_sync(serialQueue, ^{
        object = [super init];
    });
    self = object;
    return self;
}
- (void)dealloc {
}
#pragma mark -
- (void) save {
    NSError* error = nil;
	NSManagedObjectContext* managedObjectContext = [self context];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}
#pragma mark - Core Data stack
- (NSManagedObjectContext*) context {
    if (context != nil) {
        return context;
    }
    NSPersistentStoreCoordinator* storeCordinator = [self coordinator];
    if (storeCordinator != nil) {
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:storeCordinator];
    }
    return context;
}
- (NSManagedObjectModel*) model {
    if (model != nil) {
        return model;
    }
	model = [NSManagedObjectModel mergedModelFromBundles:nil]; 
    return model;
}
- (NSPersistentStoreCoordinator*) coordinator {
    if (coordinator != nil) {
        return coordinator;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* paths = paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        NSString* path = [paths objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"CadavreExquis.sqlite"];
        if (![fileManager fileExistsAtPath:path]) {
            NSString* defaultStorePath = [[NSBundle mainBundle] pathForResource:@"initialData" ofType:@"sqlite"];
            if (defaultStorePath) {
                [fileManager copyItemAtPath:defaultStorePath toPath:path error:NULL];
            }
        }
    }
    NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CadavreExquis.sqlite"];
	NSLog(@"%@",[storeURL absoluteURL]);
    NSError *error = nil;
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    return coordinator;
}
#pragma mark - Application's Documents directory
/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - methods
- (NSFetchRequest* ) createRequest:(int) type {
	NSManagedObjectContext* managedContext = [self context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Dictionary" inManagedObjectContext:managedContext]];
    [request setIncludesSubentities:NO];
    NSPredicate* predicate = [NSPredicate predicateWithFormat: [NSString stringWithFormat:@"type = %d", type]];
    [request setPredicate:predicate];
	NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sort]];
    return request;
}
- (NSUInteger) counts:(int)type {
	NSManagedObjectContext* managedContext = [self context];
    NSError* error = nil;
    NSUInteger count = [managedContext countForFetchRequest:[self createRequest:type] error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    return count;
}
- (NSString*) select:(int) type {
    NSUInteger count = [self counts:type];
	NSManagedObjectContext* managedContext = [self context];
    NSFetchRequest* request = [self createRequest:type];
	[request setFetchLimit:1];
    [request setFetchOffset:arc4random() % count];
	NSError* error = nil;
	NSMutableArray* mutableFetchResults = [[managedContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog(@"fetch error.");
	}
	return [[mutableFetchResults objectAtIndex:0] valueForKey:@"sentence"];
}
- (NSManagedObject*) newEntity {
	NSManagedObjectContext* managedContext = [self context];
	return [NSEntityDescription insertNewObjectForEntityForName:@"Dictionary" inManagedObjectContext:managedContext];
}
@end
