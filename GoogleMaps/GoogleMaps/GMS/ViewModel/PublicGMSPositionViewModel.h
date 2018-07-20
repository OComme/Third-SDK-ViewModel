//
//  PublicGMSPositionViewModel.h
//  GoogleMaps
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//
//  google 定位的逻辑

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "PublicGMSAddressDataModel.h"

@protocol PublicGMSViewModelProtocol<NSObject>

/**
 outPut new address info
 */
- (void)gms_outPutAddressInfo:(PublicGMSAddressDataModel *_Nonnull)addressModel;

@end

@interface PublicGMSPositionViewModel : NSObject<CLLocationManagerDelegate,GMSMapViewDelegate>

@property (nullable,nonatomic,weak) id<PublicGMSViewModelProtocol> delegate;

/**
 map view
 */
@property (nonnull,nonatomic,strong) GMSMapView *mapView;

- (void)locateToUserLocation;

/**
 reverse geoCode
 */
- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 geo code
 */
- (void)geocodeAddressName:(NSString *__nullable)address APIKey:(NSString *__nullable)key;

@end
