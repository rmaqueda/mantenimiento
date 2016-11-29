//
//  MOLBAseModel.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"

@implementation MOLBaseModel

//TODO: ¿Esto es necesasio? Lo puse para evitar los warnings
@synthesize images;

+ (NSString *)endpoint {
    return [[[NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"MOL"
                                                                        withString:@""] stringByAppendingString:@"/"] lowercaseString];
}

+ (NSDateFormatter *)timestampFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'";
    return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return dateFormatter;
}

+ (NSNumberFormatter *)moneyFormatter {
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    formater.locale = [NSLocale currentLocale];
    formater.numberStyle = NSNumberFormatterDecimalStyle;
    formater.maximumFractionDigits = 2;
    formater.usesGroupingSeparator = YES;
    
    return formater;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"objectId": @"id",
             @"created_at": @"created_at",
             @"updated_at": @"updated_at"
             };
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"objectId": @"objectId",
             @"created_at": @"created_at",
             @"updated_at": @"updated_at"
             };
}

+ (NSString *)managedObjectEntityName {
    //TODO: subclass responsability
    return nil;
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"objectId"];
}

+ (NSValueTransformer *)created_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.timestampFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.timestampFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updated_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.timestampFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.timestampFormatter stringFromDate:date];
    }];
}

+ (instancetype)searchObjectWithId:(NSNumber *)objectId array:(NSArray *)array {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", objectId];
    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    
    return filteredArray.count > 0 ? filteredArray.firstObject : nil;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[MOLBaseModel class]]) {
        MOLBaseModel *compareObject = (MOLBaseModel *)object;
        
        return [self.objectId isEqual:compareObject.objectId];
    }
    
    return NO;
}

- (NSString *)title {
    //TODO: implementar en sub-clases
    return nil;
}

- (NSString *)subTitle1 {
    return nil;
}

- (NSString *)subTitle2 {
    return nil;
}

- (NSURL *)URLfirstImage {
    return nil;
}

- (NSURL *)URLramdonImage {
    return nil;
}

@end
