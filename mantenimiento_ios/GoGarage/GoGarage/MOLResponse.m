//
//  MOLResponse.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLResponse.h"
#import "MOLResult.h"

@implementation MOLResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"count": @"count",
             @"next": @"next",
             @"previous": @"previous",
             @"results": @"results"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:MOLResult.class];
}

@end
