//
//  MOLService.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 02/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"


@interface MOLService : MOLBaseModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *serviceDescription;

@end
