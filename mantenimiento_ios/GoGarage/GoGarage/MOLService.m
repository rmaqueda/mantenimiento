//
//  MOLService.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 02/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLService.h"

@implementation MOLService

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *keys = @{
                           @"type": @"type",
                           @"serviceDescription": @"description"
                           };
    
    return [keys mtl_dictionaryByAddingEntriesFromDictionary:[super JSONKeyPathsByPropertyKey]];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    NSDictionary *keys = @{
                           @"type": @"type",
                           @"serviceDescription": @"serviceDescription"
                           };
    return [keys mtl_dictionaryByAddingEntriesFromDictionary:[super managedObjectKeysByPropertyKey]];
}

+ (NSString *)managedObjectEntityName {
    return @"Service";
}


- (NSString *)title {
    return self.type;
}

- (NSString *)subTitle1 {
    return self.serviceDescription;
}

- (NSString *)subTitle2 {
    return nil;
}

@end
