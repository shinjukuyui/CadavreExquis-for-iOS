//
//  Dictionary.h
//  CadavreExquis4iOS
//
//  Copyright (c) 2012 Tragile-Eden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dictionary : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * initial;
@property (nonatomic, retain) NSNumber * inUse;
@property (nonatomic, retain) NSString * sentence;
@property (nonatomic, retain) NSNumber * type;

@end
