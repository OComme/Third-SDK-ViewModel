//
//  PublicGMSAddressDataModel.h
//  GoogleMaps
//
//  Created by Mac on 2018/7/20.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicGMSAddressDataModel : NSObject

@property (nonnull,nonatomic,copy) NSString *country;

@property (nonnull,nonatomic,copy) NSString *province;

@property (nonnull,nonatomic,copy) NSString *city;

@property (nonnull,nonatomic,copy) NSString *regin;

@property (nonnull,nonatomic,copy) NSString *postal_code;

/**
 full address
 */
@property (nonnull,nonatomic,copy) NSString *needAddress;

- (void)upDateForNewModel:(PublicGMSAddressDataModel *_Nonnull)newModel;

- (BOOL)isIntact;

@end
