//
//  MOLResult.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MOLResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSArray *results;

@end
