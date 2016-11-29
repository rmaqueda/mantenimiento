//
//  MOLResponse.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MOLResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSURL *next;
@property (nonatomic, strong) NSURL *previous;
@property (nonatomic, copy) NSArray *results;

@end
