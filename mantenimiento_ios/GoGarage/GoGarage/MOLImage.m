//
//  MOLImage.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLImage.h"

@implementation MOLImage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *keys = @{
                           @"objectID": @"vehicle",
                           @"url": @"image"
                           };
    
    return [keys mtl_dictionaryByAddingEntriesFromDictionary:[super JSONKeyPathsByPropertyKey]];
}

@end
