//
//  MOLBAseModel.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>

@protocol APIDrawableObject <NSObject, MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, strong) UIImage *image;

+ (NSString *)endpoint;
+ (NSString *)managedObjectEntityName;
- (NSString *)title;
- (NSString *)subTitle1;
- (NSString *)subTitle2;

- (NSURL *)URLfirstImage;
- (NSURL *)URLramdonImage;

@end

@interface MOLBaseModel : MTLModel <APIDrawableObject, MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *updated_at;
@property (nonatomic, strong) UIImage *image;

+ (NSString *)endpoint;
+ (NSString *)managedObjectEntityName;
+ (NSDateFormatter *)timestampFormatter;
+ (NSDateFormatter *)dateFormatter;
+ (NSNumberFormatter *)moneyFormatter;
+ (instancetype)searchObjectWithId:(NSNumber *)objectId array:(NSArray *)array;

- (NSString *)title;
- (NSString *)subTitle1;
- (NSString *)subTitle2;

- (NSURL *)URLfirstImage;
- (NSURL *)URLramdonImage;

@end
