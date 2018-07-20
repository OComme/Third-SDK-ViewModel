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
        _country = @"";
        _city    = @"";
        _regin   = @"";
        _needAddress = @"";
        _postal_code = @"";
    }
    return self;
}

//- (NSDictionary *)properties_aps {
//    NSMutableDictionary *props = [NSMutableDictionary dictionary];
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
//    for (i = 0; i<outCount; i++)
//    {
//        objc_property_t property = properties[i];
//        const char* char_f =property_getName(property);
//        NSString *propertyName = [NSString stringWithUTF8String:char_f];
//        id propertyValue = [self valueForKey:(NSString *)propertyName];
//        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
//    }
//    free(properties);
//
//    return props;
//}

- (BOOL)isIntact
{
    return self.country.length || self.city.length || self.regin.length || self.needAddress.length || self.province.length;
}

@end
