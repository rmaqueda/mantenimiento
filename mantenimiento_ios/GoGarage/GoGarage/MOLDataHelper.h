//
//  MOLDataHelper.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 23/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"

@protocol MOLDataHelperDelegate <NSObject>

- (void)dataHelpeDidReciveObjectsOfClass:(Class<APIDrawableObject>)objectClass
                                objects:(NSArray *)objects;

@end


@interface MOLDataHelper : NSObject

@property (nonatomic, weak) id<MOLDataHelperDelegate> delegate;

- (NSArray *)objectsForClass:(Class<APIDrawableObject>)objectClass;

- (void)saveObject:(id<APIDrawableObject>)object
   completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block;

- (void)updateObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block;

- (void)deleteObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error))block;


@end
