//
//  MOLCoreDataStack.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 23/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

@import CoreData;
#import "MOLBaseModel.h"

@interface MOLCoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *mainMOC;
//@property (strong, nonatomic, readonly) NSManagedObjectContext *backgroundMOC;

+ (instancetype)sharedInstance;

- (void)deleteAllData;

- (NSArray *)objectsForClass:(Class<APIDrawableObject>)objectClass;

- (id)objectForClass:(Class<APIDrawableObject>)objectClass withId:(NSNumber *)objectId;

- (void)saveObject:(id)object
   completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block;

- (void)updateObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block;

- (void)deleteObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error))block;

@end
