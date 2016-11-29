//
//  MOLLocal.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLLocal.h"

@implementation MOLLocal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *keys = @{
                           @"name": @"name",
                           @"contact": @"contact",
                           @"telephone": @"telephone",
                           @"address": @"address",
                           @"localDescription": @"description"
                           };
    return [keys mtl_dictionaryByAddingEntriesFromDictionary:[super JSONKeyPathsByPropertyKey]];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    NSDictionary *keys = @{
                           @"name": @"name",
                           @"contact": @"contact",
                           @"telephone": @"telephone",
                           @"address": @"address",
                           @"localDescription": @"localDescription"
                           };
    return [keys mtl_dictionaryByAddingEntriesFromDictionary:[super managedObjectKeysByPropertyKey]];
}

+ (NSString *)managedObjectEntityName {
    return @"Local";
}

- (NSString *)title {
    return _name;
}

- (NSString *)subTitle1 {
    return _contact;
}

- (NSString *)subTitle2 {
    return _address;
}

@end
