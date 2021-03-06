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

NSArray *ignorePropertys;
//NSDictionary *dicData;
@implementation SSObject


-(id)initWithData:(NSData *)data{
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    if (dic) {
        self = [super init];
        if (self) {
            [self install:dic];
        }
        return self;
    }
    return nil;
    
}

-(id)initWithJson:(NSString *)json{
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    if (dic) {
        self = [super init];
        if (self) {
            [self install:dic];
        }
        return self;
    }
    return nil;
}

-(id)initWithDictionary:(id)dictionary{
    if (dictionary && ![dictionary isKindOfClass:[NSNull class]]) {
        self = [super init];
        if (self) {
            [self install:dictionary];
        }
        return self;
    }
    return nil;
    
}

-(void)install:(NSDictionary *)dictionary{
//    dicData = dictionary;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSMutableArray *attributes = [NSMutableArray new];
    NSMutableArray *property = [NSMutableArray new];
    Class cl = [self class];
    while (cl != [SSObject class]) {
        NSArray *attr = NULL;
        [property addObjectsFromArray:[self getAllProperty:&attr class:cl]];
        [attributes addObjectsFromArray:attr];
        cl = [cl superclass];
    }
    for (NSString *key in property) {
        if (![dictionary[key] isKindOfClass:[NSNull class]] && dictionary[key] != nil) {
            @try {
                if (NSClassFromString([attributes[[property indexOfObject:key]] attribute]) == [NSNumber class] && ![dictionary[key] isKindOfClass:[NSNumber class]]) {
                    
                    NSNumber *number = [[f numberFromString:dictionary[key]] copy];
                    [self setValue:number forKey:key];
                }else{
                    [self setValue:[dictionary[key] copy] forKey:key];
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

- (NSDictionary *)dictionary{
    NSMutableArray *attributes = [NSMutableArray new];//NULL;
    NSMutableArray *property = [NSMutableArray new];//[self getAllProperty:&attributes class:[self class]];
    Class cl = [self class];
    while (cl != [SSObject class]) {
        NSArray *attr = NULL;
        [property addObjectsFromArray:[self getAllProperty:&attr class:cl]];
        [attributes addObjectsFromArray:attr];
        cl = [cl superclass];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (NSString *name in property) {
        id item = [self valueForKey:name];
        if ([item isKindOfClass:[NSString class]] || [item isKindOfClass:[NSNumber class]] || [item isKindOfClass:[NSDictionary class]] || [item isKindOfClass:[NSArray class]]) {
            if ([ignorePropertys containsObject:name]) {
                continue;
            }
            if ([item isKindOfClass:[NSArray class]]) {
                NSMutableArray *marray = [NSMutableArray new];
                for (id aitem in item) {
                    if ([aitem isKindOfClass:[SSObject class]]) {
                        [marray addObject:[aitem dictionary]];
                    }else{
                        [marray addObject:aitem];
                    }
                }
                dic[name] = marray;
            }else{
                dic[name] = item;
            }
        }else if([item isKindOfClass:[SSObject class]]){
            dic[name] = [item dictionary];
        }
    }
    return dic;
}

//获取类的所有的 属性的名字
-(NSArray *)getAllProperty:(NSArray **)attributes class:(Class)class
{
    unsigned int count;
    NSMutableArray *rv = [NSMutableArray array];
    NSMutableArray *av = [NSMutableArray array];
    objc_property_t *properties = class_copyPropertyList(class, &count);
    unsigned int i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        [rv addObject:name];
        [av addObject:@(property_getAttributes(property))];
        //         NSString *attributes = @(property_getAttributes(property));//获取属性类型
    }
    if (attributes) {
        *attributes = av;
    }
    free(properties);
    return rv;
}

-(void)addIgnorePropertys:(NSArray *)propertys{
    ignorePropertys = propertys;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        // Copy NSObject subclasses
        NSArray *property = [copy getAllProperty:nil class:[self class]];
        for (NSString *name in property) {
            [copy setValue:[[self valueForKey:name] copyWithZone:zone] forKey:name];
        }
    }
    
    return copy;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.dictionary];
}

@end
