//
//  MOLVehicle.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"


@interface MOLVehicle : MOLBaseModel

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *registrationNumber;
@property (nonatomic, copy) NSString *chassisNumber;
@property (nonatomic, strong) NSDate *manufacturedDate;
@property (nonatomic, copy) NSString *vehicleDescription;

@end
