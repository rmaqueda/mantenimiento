//
//  MOLResult.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLResult.h"
#import "MOLVehicle.h"
#import "MOLImage.h"
#import "MOLLocal.h"
#import "MOLService.h"
#import "MOLMaintenanceBook.h"

@implementation MOLResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"results": @"results"
             };
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    
    if (JSONDictionary[@"brand"] != nil) {
        return MOLVehicle.class;
    }
    
    if (JSONDictionary[@"address"] != nil) {
        return MOLLocal.class;
    }
    
    if (JSONDictionary[@"image"]) {
        return MOLImage.class;
    }
    
    if (JSONDictionary[@"type"]) {
        return MOLService.class;
    }
    
    if (JSONDictionary[@"price"]) {
        return MOLMaintenanceBook.class;
    }
    
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}

@end
