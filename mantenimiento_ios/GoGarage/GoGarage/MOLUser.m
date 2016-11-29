//
//  MOLUser.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 02/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLUser.h"

@implementation MOLUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"objectId": @"id",
             @"username": @"username",
             @"first_name": @"first_name",
             @"last_name": @"last_name",
             @"email": @"email",
             @"staff": @"is_staff",
             @"active": @"is_active"
             };
}

+ (NSString *)endpoint {
    return @"user/";
}

@end
