//
//  MOLPaginationManager.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 03/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"


@interface MOLPaginationManager : NSObject

@property (assign, readonly) NSInteger totalObjects;
@property (nonatomic, strong) NSMutableArray *results;

- (instancetype)initWithClass:(Class<APIDrawableObject>)classObject
                     pageSize:(NSInteger)pageSize
                      filters:(NSArray *)filers;

- (UIView *)activityIndicatorView:(UIView *)view;
- (void)nextPageWithBlock:(void (^) (NSError *error))block;

@end
