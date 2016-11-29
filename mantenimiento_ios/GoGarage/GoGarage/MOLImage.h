//
//  MOLImage.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 31/12/15.
//  Copyright © 2015 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"


@interface MOLImage : MOLBaseModel

@property (nonatomic, strong) NSNumber *objectID;
@property (nonatomic, strong) NSURL *url;

@end
