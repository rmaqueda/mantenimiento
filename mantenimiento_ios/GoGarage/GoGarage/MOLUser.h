//
//  MOLUser.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 02/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"


@interface MOLUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *first_name;
@property (nonatomic, copy) NSString *last_name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, getter=is_staff) BOOL staff;
@property (nonatomic, getter=is_active) BOOL active;

+ (NSString *)endpoint;

@end
