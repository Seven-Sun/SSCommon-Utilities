//
//  SSObject.m
//  SSCommon
//
//  Created by Seven on 15-1-14.
//  Copyright (c) 2015年 Allgateways. All rights reserved.
//

#import "SSObject.h"
#import <objc/runtime.h>
#import "NSString+Attribute.h"

@implementation SSObject

-(id)initWithDictionary:(id)dictionary{
    if (dictionary && ![dictionary isKindOfClass:[NSNull class]]) {
        self = [super init];
        if (self) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            NSArray *attributes = NULL;
            NSArray *property = [self getAllProperty:&attributes class:[self class]];
            for (NSString *key in property) {
                if (![dictionary[key] isKindOfClass:[NSNull class]] && dictionary[key] != nil) {
                    @try {
                        if (NSClassFromString([attributes[[property indexOfObject:key]] attribute]) == [NSNumber class] && ![dictionary[key] isKindOfClass:[NSNumber class]]) {
                            
                            NSNumber *number = [f numberFromString:dictionary[key]];
                            [self setValue:number forKey:key];
                        }else{
                            [self setValue:dictionary[key] forKey:key];
                        }
                        
                    }
                    @catch (NSException *exception) {
                        NSLog(@"error create object %@",exception);
                    }
                    @finally {
                        
                    }
                    
                }
            }
        }
        return self;
    }
    return nil;
    
}

- (NSDictionary *)dictionary{
    NSArray *attributes = NULL;
    NSArray *property = [self getAllProperty:&attributes class:[self class]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (NSString *name in property) {
        
        if ([name isEqualToString:@"method"]) {
            break;
        }
        
        id item = [self valueForKey:name];
        if ([item isKindOfClass:[NSString class]] || [item isKindOfClass:[NSNumber class]] || [item isKindOfClass:[NSDictionary class]] || [item isKindOfClass:[NSArray class]]) {
            dic[name] = item;
        }
        
    }
    return dic;
}

//获取类的所有的 属性的名字
-(NSArray *)getAllProperty:(NSArray **)attributes class:(Class)class
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSMutableArray *rv = [NSMutableArray array];
    NSMutableArray *av = [NSMutableArray array];
    unsigned int i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        [rv addObject:name];
        [av addObject:@(property_getAttributes(property))];
        //         NSString *attributes = @(property_getAttributes(property));//获取属性类型
    }
    *attributes = av;
    free(properties);
    return rv;
}

@end