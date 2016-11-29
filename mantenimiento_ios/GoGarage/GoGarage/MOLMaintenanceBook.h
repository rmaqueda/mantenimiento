//
//  MOLMaintenanceBook.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 02/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"


@interface MOLMaintenanceBook : MOLBaseModel

@property (nonatomic, strong) NSNumber *vehicleId;
@property (nonatomic, strong) NSNumber *serviceId;
@property (nonatomic, strong) NSNumber *localId;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *kilometers;



@end


