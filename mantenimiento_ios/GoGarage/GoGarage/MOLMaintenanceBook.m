//
//  MOLMaintenanceBook.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 02/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLMaintenanceBook.h"


@implementation MOLMaintenanceBook

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *keys = @{
                           @"vehicleId": @"vehicle",
                           @"localId": @"local",
                           @"serviceId": @"service",
                           @"date": @"date",
                           @"price": @"price",
                           @"kilometers": @"kilometers"
                           };
    
    return [keys mtl_dictionaryByAddingEntriesFromDictionary:[super JSONKeyPathsByPropertyKey]];
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
