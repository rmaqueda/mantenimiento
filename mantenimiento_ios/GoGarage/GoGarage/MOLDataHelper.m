//
//  MOLDataHelper.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 23/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLDataHelper.h"
#import "MOLNetworkManager.h"
#import "MOLCoreDataStack.h"

@interface MOLDataHelper ()


@end

@implementation MOLDataHelper

- (NSArray *)objectsForClass:(Class<APIDrawableObject>)objectClass {
    
    NSArray *localresults = [[MOLCoreDataStack sharedInstance] objectsForClass:objectClass];
    NSLog(@"Resultado en BD: %i", (int)localresults.count);
    
    
    [[MOLNetworkManager sharedInstance] objectsOfClass:objectClass
                                       completionBlock:^(NSError *error, MOLResponse *response)
     {
         if (!error) {
             
             NSLog(@"Resultado de Red: %i", (int)response.results.count);
             NSMutableArray *matchResults = [NSMutableArray arrayWithCapacity:response.results.count];
             
             // Match network with DB
             for (id object in response.results) {
                 if (![localresults containsObject:object]) {
                     [self saveObjectLocaly:object completionBlock:nil];
                     [matchResults addObject:object];
                 }
             }
             
             // Match DB with Network
             for (id object in localresults) {
                 if (![response.results containsObject:object]) {
                     [self saveObjectRemotely:object completionBlock:nil];
                 }
             }
             
             if (matchResults.count) {
                 if ([self.delegate respondsToSelector:@selector(dataHelpeDidReciveObjectsOfClass:objects:)]) {
                     [self.delegate dataHelpeDidReciveObjectsOfClass:objectClass objects:matchResults];
                 }
             }
         }
     }];
    
    return localresults;
}


- (void)saveObjectRemotely:(id)object
           completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block
{
    [[MOLNetworkManager sharedInstance] saveObject:object completionBlock:^(NSError *error, id<APIDrawableObject> object) {
        !block ?: block(error, object);
    }];
}

- (void)saveObjectLocaly:(id)object
         completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block
{
    [[MOLCoreDataStack sharedInstance] saveObject:object completionBlock:^(NSError *error, id<APIDrawableObject> object) {
        !block ?: block(error, object);
    }];
}


- (void)saveObject:(id<APIDrawableObject>)object
   completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block
{
    [self saveObjectRemotely:object completionBlock:^(NSError *error, id<APIDrawableObject> object) {
        if (!error) {
            [self saveObjectLocaly:object completionBlock:^(NSError *error, id<APIDrawableObject> object) {
                !block ?: block(error, object);
            }];
        } else {
            !block ?: block(error, nil);
        }
    }];
    
}

- (void)updateObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block
{
    
}

- (void)deleteObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error))block
{
    [[MOLNetworkManager sharedInstance] deleteObject:object completionBlock:^(NSError *error) {
        if (!error) {
            [[MOLCoreDataStack sharedInstance] deleteObject:object completionBlock:^(NSError *error) {
                !block ?: block(error);
            }];
        } else {
            !block ?: block(error);
        }
    }];
}

@end
