//
//  MOLMaintenanceBookDetails.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 02/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLMaintenanceBook.h"
#import "MOLVehicle.h"
#import "MOLService.h"
#import "MOLLocal.h"

@interface MOLMaintenanceBookDetails : MOLBaseModel

@property (nonatomic, strong) MOLVehicle *vehicle;
@property (nonatomic, strong) MOLService *service;
@property (nonatomic, strong) MOLLocal *local;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *kilometers;

@end


