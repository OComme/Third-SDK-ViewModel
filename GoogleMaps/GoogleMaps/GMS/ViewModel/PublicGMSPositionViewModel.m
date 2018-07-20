//
//  PublicGMSPositionViewModel.m
//  GoogleMaps
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//

#import "PublicGMSPositionViewModel.h"
#import "PublicGMSFetchModel.h"

#import <PTFetchManager.h>

@interface PublicGMSPositionViewModel ()

@property (nonnull,nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic,assign) CLLocationCoordinate2D userLocation;

@property (nonnull,nonatomic,strong) GMSMarker *currentLocateMaker;

/**
 geoCode fetch
 */
@property (nonnull,nonatomic,strong) PublicGMSFetchModel *fetchModel_geoCode;

@end

@implementation PublicGMSPositionViewModel

- (void)setMapView:(GMSMapView *)mapView
{
    _mapView = mapView;
    mapView.delegate = self;
    
    self.currentLocateMaker.map = mapView;
    mapView.selectedMarker = self.currentLocateMaker;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate  = self;
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark-event
- (void)locateToUserLocation
{
    [self.mapView animateToLocation:self.userLocation];
}

#pragma mark-geoCode
- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate
{
    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
        if (response.firstResult) {
            PublicGMSAddressDataModel *addressModel = [PublicGMSAddressDataModel new];
            addressModel.country = response.firstResult.country;
            addressModel.province = response.firstResult.administrativeArea;
            addressModel.city = response.firstResult.locality;
            addressModel.regin = response.firstResult.subLocality;
            addressModel.needAddress = response.firstResult.lines.firstObject;
            
            [self.delegate gms_outPutAddressInfo:addressModel];
        }
    }];
}

- (void)geocodeAddressName:(NSString *)address APIKey:(NSString *)key
{
    self.fetchModel_geoCode.parametDict = @{@"address":address,@"key":key};
    
    __weak typeof(self) weakSelf = self;
    self.fetchModel_geoCode.succeed = ^(NSDictionary * responseDict) {
        NSArray *addressArray = responseDict[@"results"][0][@"address_components"];
        if ([addressArray isKindOfClass:[NSArray class]] == NO) {
            return ;
        }
        PublicGMSAddressDataModel *addressModel = [PublicGMSAddressDataModel new];
        NSString *addressStr = responseDict[@"results"][0][@"formatted_address"];
        addressStr = [addressStr componentsSeparatedByString:@"邮政编码"].firstObject;
        addressModel.needAddress = addressStr;
        for (NSDictionary *infoDict in addressArray) {
            NSString *key = [weakSelf keyForTypes:infoDict[@"types"]];
            if (key == nil) {
                continue;
            }
            [addressModel setValue:infoDict[@"long_name"] forKey:key];
        }
        [weakSelf.delegate gms_outPutAddressInfo:addressModel];
    };
    [PTFetchManager Fetch_GETData:self.fetchModel_geoCode];
}

- (NSString *)keyForTypes:(NSArray *)types
{
    if ([types containsObject:@"country"]) {
        return @"country";
    }
    if ([types containsObject:@"administrative_area_level_1"]) {
        return @"province";
    }
    if ([types containsObject:@"locality"] || [types containsObject:@"administrative_area_level_2"]) {
        return @"city";
    }
    if ([types containsObject:@"sublocality"] || [types containsObject:@"natural_feature"] || [types containsObject:@"establishment"]) {
        return @"regin";
    }
    if ([types containsObject:@"postal_code"]) {
        return @"postal_code";
    }
    return nil;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.userLocation = locations.firstObject.coordinate;
    self.mapView.camera = [[GMSCameraPosition alloc] initWithTarget:self.userLocation zoom:15 bearing:0 viewingAngle:0];
    [self.locationManager stopUpdatingLocation];
}

#pragma  mark - Mapview Delegate
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self reverseGeocodeCoordinate:marker.position];
}

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    if (mapView.myLocationEnabled == NO) {
        [self locateToUserLocation];
    }
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:position.target completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
        if (response.firstResult == nil) {
            return ;
        }
        self.currentLocateMaker.position = position.target;
        
        self.currentLocateMaker.title = response.firstResult.lines.firstObject;
        mapView.selectedMarker = self.currentLocateMaker;
    }];
    
//    [self reverseGeocodeCoordinate:position.target completionHandler:^(PublicGMSAddressDataModel * _Nullable addressModel) {
//
//    }];
}

#pragma mark-lazyload
- (GMSMarker *)currentLocateMaker
{
    if (_currentLocateMaker == nil){
        _currentLocateMaker = [GMSMarker new];
        
        _currentLocateMaker.icon = [UIImage imageNamed:@"issue_location_icon"];
    }
    return _currentLocateMaker;
}

- (PublicGMSFetchModel *)fetchModel_geoCode
{
    if (_fetchModel_geoCode == nil) {
        _fetchModel_geoCode = [PublicGMSFetchModel new];
        _fetchModel_geoCode.urlString = @"https://maps.googleapis.com/maps/api/geocode/json";
    }
    return _fetchModel_geoCode;
}

@end
