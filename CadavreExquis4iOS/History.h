//
//  History.h
//  CadavreExquis4iOS
//
//  Created by 花木 香織 on 12/04/30.
//  Copyright (c) 2012年 Tragile Eden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface History : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * sentence;

@end
