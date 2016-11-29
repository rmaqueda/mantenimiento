//
//  MOLVehicle.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLVehicle.h"
#import "MOLImage.h"
#import "NSDictionary+MTLManipulationAdditions.h"

@implementation MOLVehicle

@synthesize image;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *keys = @{
                           @"nick": @"nick",
                           @"brand": @"brand",
                           @"model": @"model",
                           @"color": @"color",
                           @"chassisNumber": @"chassisNumber",
                           @"manufacturedDate": @"manufacturedDate",
                           @"registrationNumber": @"registrationNumber",
                           @"vehicleDescription": @"description",
                           @"images": @"images"
                           };
    
    return [keys mtl_dictionaryByAddingEntriesFromDictionary:[super JSONKeyPathsByPropertyKey]];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    NSDictionary *keys = @{
                           @"nick": @"nick",
                           @"brand": @"brand",
                           @"model": @"model",
                           @"color": @"color",
                           @"chassisNumber": @"chassisNumber",
                           @"manufacturedDate": @"manufacturedDate",
                           @"registrationNumber": @"registrationNumber",
                           @"vehicleDescription": @"vehicleDescription",
                           };
    return [keys mtl_dictionaryByAddingEntriesFromDictionary:[super managedObjectKeysByPropertyKey]];
}

+ (NSString *)managedObjectEntityName {
    return @"Vehicle";
}

+ (NSValueTransformer *)manufacturedDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)imagesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:MOLImage.class];
}

- (NSString *)title {
    return self.nick;
}

- (NSString *)subTitle1 {
    return self.brand;
}

- (NSString *)subTitle2 {
    return self.model;
}

- (NSURL *)URLfirstImage {
    if (self.images.count) {
        MOLImage *imageMOL = self.images[0];
        NSString *relative = [imageMOL.url relativePath];
        NSString *insecureURL = [NSString stringWithFormat:@"http://molestudio.es%@", relative];
        
        return [NSURL URLWithString:insecureURL];
    } else {
        return nil;
    }
}

- (NSURL *)URLramdonImage; {
    if (self.images.count) {
        int r = arc4random_uniform((int)self.images.count);
        MOLImage *imageMOL = self.images[r];
        NSString *relative = [imageMOL.url relativePath];
        NSString *insecureURL = [NSString stringWithFormat:@"http://molestudio.es%@", relative];
        
        return [NSURL URLWithString:insecureURL];
    } else {
        return nil;
    }
}

@end
