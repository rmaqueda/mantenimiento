//
//  MOLNetworkManager.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 30/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import "MOLBaseModel.h"
#import "MOLResponse.h"
#import "MOLUser.h"

@interface MOLNetworkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)registerUsername:(NSString *)username email:(NSString *)email password:(NSString *)password
         completionBlock:(void (^) (NSError *error, MOLUser *user))block;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
          completionBlock:(void (^) (NSError *error))block;

- (void)loginWithLastUserNameWithCompletionBlock:(void (^) (NSError *error))block;

- (void)logoutWithCompletionBlock:(void (^) (NSError *error))block;

- (void)objectOfClass:(Class<APIDrawableObject>)classObject withId:(NSNumber *)objectId
      completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block;

- (void)objectsOfClass:(Class<APIDrawableObject>)classObject
       completionBlock:(void (^) (NSError *error, MOLResponse *response))block;

- (void)objects:(Class<APIDrawableObject>)classObject
       pageSize:(NSUInteger)pageSize
           page:(NSUInteger)page
        filters:(NSArray *)filters
completionBlock:(void (^) (NSError *error, NSArray *objects, NSUInteger nextPage, NSUInteger totalObjects))block;

- (void)saveObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block;

- (void)updateObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error, id<APIDrawableObject>object))block;

- (void)deleteObject:(id<APIDrawableObject>)object
     completionBlock:(void (^) (NSError *error))block;

@end
