//
//  MOLLocal.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"

@interface MOLLocal : MOLBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *address;
//TODO: latitude, longitude;
@property (nonatomic, copy) NSString *localDescription;

@end
