//
//  ClassUtils.h
//  Table Editable Model
//
//  Created by Ricardo Maqueda Martinez on 14/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//


@interface MOLRuntimeHelper : NSObject

+ (NSArray *)dictionaryPropertiesNameTypeForClass:(Class)className
                                       classTypes:(NSArray *)classTypes;

@end
