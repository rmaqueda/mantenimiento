//
//  MOLMaintenanceBookDetails.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 02/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLMaintenanceBookDetails.h"


@implementation MOLMaintenanceBookDetails

+ (NSString *)endpoint {
    return [MOLMaintenanceBook endpoint];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *keys = @{
                           @"vehicle": @"vehicle",
                           @"local": @"local",
                           @"service": @"service",
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

+ (NSValueTransformer *)vehicleJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:MOLVehicle.class];
}

+ (NSValueTransformer *)localJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:MOLLocal.class];
}

+ (NSValueTransformer *)serviceJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:MOLService.class];
}

- (NSString *)title {
    return self.service.type;
}

- (NSString *)subTitle1 {
    return [self.price stringValue];
}

- (NSString *)subTitle2 {
    return [[MOLBaseModel dateFormatter] stringFromDate:self.date];
}

@end
