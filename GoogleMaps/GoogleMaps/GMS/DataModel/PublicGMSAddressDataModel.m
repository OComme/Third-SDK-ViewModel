//
//  PublicGMSAddressDataModel.m
//  GoogleMaps
//
//  Created by Mac on 2018/7/20.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//

#import "PublicGMSAddressDataModel.h"
//#import <objc/runtime.h>

@implementation PublicGMSAddressDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (NSString *key in [self propertieKeys]) {
            [self setValue:@"" forKey:key];
        }
    }
    return self;
}

- (NSArray *)propertieKeys {
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        [props addObject:[NSString stringWithUTF8String:char_f]];
    }
    free(properties);

    return props;
}

- (void)upDateForNewModel:(PublicGMSAddressDataModel *)newModel
{
    for (NSString *key in [self propertieKeys]) {
        [self setValue:[newModel valueForKey:key] forKey:key];
    }    
}

- (BOOL)isIntact
{
    return self.country.length || self.city.length || self.regin.length || self.needAddress.length || self.province.length;
}

@end
