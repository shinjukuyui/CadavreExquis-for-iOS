//
//  Dictionary.m
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import "DictionaryProxy.h"
#import "History.h"

@interface DictionaryProxy()
- (NSFetchRequest* ) createRequest:(NSString*)entity withType:(int)type ascending:(BOOL)ascending;
- (NSUInteger) counts:(NSString*)entity withType:(int)type;
@end

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
- (void) initializeData {
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
}
- (NSPersistentStoreCoordinator*) coordinator {
    if (coordinator != nil) {
        return coordinator;
    }
    [self initializeData];
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
- (NSFetchRequest* ) createRequest:(NSString*)entity withType:(int)type ascending:(BOOL)ascending {
	NSManagedObjectContext* managedContext = [self context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:managedContext]];
    [request setIncludesSubentities:NO];
    if (type >= 0) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat: [NSString stringWithFormat:@"type = %d", type]];
        [request setPredicate:predicate];
    }
	NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:ascending];
	[request setSortDescriptors:[NSArray arrayWithObject:sort]];
    return request;
}
- (NSUInteger) counts:(NSString*)entity withType:(int)type {
	NSManagedObjectContext* managedContext = [self context];
    NSError* error = nil;
    NSUInteger count = [managedContext countForFetchRequest:[self createRequest:entity withType:type ascending:YES] error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    return count;
}
- (NSMutableArray*) selectAll:(NSString*)entity withType:(int)type ascending:(BOOL)ascending {
    NSFetchRequest* request = [self createRequest:entity withType:type ascending:ascending];
	NSError* error = nil;
	NSManagedObjectContext* managedContext = [self context];
	NSMutableArray* mutableFetchResults = [[managedContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog(@"fetch error.");
        return nil;
	}
    if ([mutableFetchResults count] == 0) {
        return nil;
    }
    return mutableFetchResults;
}
- (NSMutableArray*) selectAt:(NSString*)entity withType:(int)type ascending:(BOOL)ascending indexOf:(int)index {
    NSMutableArray* array = [self selectAll:entity withType:type ascending:ascending];
    if (array == nil || [array count] == 0) {
        return nil;
    }
    return [array objectAtIndex:index];
}
- (NSManagedObject*) select:(NSString*)entity withType:(int)type isRandom:(BOOL)random withLimit:(int)limit ascending:(BOOL)ascending {
    NSFetchRequest* request = [self createRequest:entity withType:type ascending:ascending];
	[request setFetchLimit:limit];
    if (random == YES) {
        NSUInteger count = [self counts:entity withType:type];
        [request setFetchOffset:arc4random() % count];
    } else {
    }
	NSError* error = nil;
	NSManagedObjectContext* managedContext = [self context];
	NSMutableArray* mutableFetchResults = [[managedContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog(@"fetch error.");
        return nil;
	}
    if ([mutableFetchResults count] == 0) {
        return nil;
    }
	return [mutableFetchResults objectAtIndex:0];
}
- (NSManagedObject*) selectById:(NSString*) entity byId:(int)objectId {
    NSFetchRequest* request = [self createRequest:entity withType:-1 ascending:YES];
    NSPredicate* predicate = [NSPredicate predicateWithFormat: [NSString stringWithFormat:@"id = %d", objectId]];
    [request setPredicate:predicate];
	NSError* error = nil;
	NSManagedObjectContext* managedContext = [self context];
	NSMutableArray* mutableFetchResults = [[managedContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		NSLog(@"fetch error.");
        return nil;
	}
    if ([mutableFetchResults count] == 0) {
        return nil;
    }
	return [mutableFetchResults objectAtIndex:0];
}
- (NSManagedObject*) newEntity:(NSString*) entity {
	NSManagedObjectContext* managedContext = [self context];
	return [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:managedContext];
}
- (void) remove:(NSManagedObject*)entity {
	NSManagedObjectContext* managedContext = [self context];
    [managedContext deleteObject:entity];
}
@end
