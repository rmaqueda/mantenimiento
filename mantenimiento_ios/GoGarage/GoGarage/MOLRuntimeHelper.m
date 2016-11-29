//
//  ClassUtils.m
//  Table Editable Model
//
//  Created by Ricardo Maqueda Martinez on 14/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLRuntimeHelper.h"
#import <objc/runtime.h>


@implementation MOLRuntimeHelper

+ (NSArray *)dictionaryPropertiesNameTypeForClass:(Class)className
                                        classTypes:(NSArray *)classTypes
{
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(className, &count);

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for (unsigned i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attibutes = [NSString stringWithUTF8String:property_getAttributes(property)];
        NSArray *attrArray = [attibutes componentsSeparatedByString:@","];
        NSString *type = attrArray[0];
        
        NSString *typeClassName;
        if ([type hasPrefix:@"T@"]) {
            typeClassName = [type substringWithRange:NSMakeRange(3, [type length]-4)];
            
            if (![classTypes containsObject:typeClassName]) {
                continue;
            }
        }
        
        NSDictionary *dictionary = @{
                                     @"name" : name,
                                     @"class" : typeClassName
                                     };
        
        [array addObject:dictionary];
    }
    
    free(properties);
    
    return array;
}

@end
