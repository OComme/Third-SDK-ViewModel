//
//  PublicGMSRetrieveViewModel.m
//  GoogleMaps
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//

#import "PublicGMSRetrieveViewModel.h"

@interface PublicGMSRetrieveViewModel ()

/**
 大头针集合
 */
@property (nonnull,nonatomic,strong) NSMutableArray<GMSMarker *> *feedEntity_marker;

#warning oldCoord Need to be officially removed
/**
 上一次定位的坐标
 */
@property (nonatomic,assign) CLLocationCoordinate2D oldCoord;

@end

@implementation PublicGMSRetrieveViewModel

#pragma  mark - Mapview Delegate
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    [super mapView:mapView didChangeCameraPosition:position];
    
    if (fabs(position.target.longitude - self.oldCoord.longitude)*10000 < 4 || fabs(position.target.latitude - self.oldCoord.latitude)*10000 < 4) {
        return;
    }
    self.oldCoord = position.target;
    
    [self.feedEntity_marker makeObjectsPerformSelector:@selector(setMap:) withObject:nil];
    [self.feedEntity_marker removeAllObjects];
    
    for (NSUInteger index = 0; index < 20; index ++) {
        GMSMarker *maker = [GMSMarker new];
        maker.title = [NSString stringWithFormat:@"%@",@(index)];
        
        UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"map_loc_icon_0%@", @(arc4random() % 6 + 1)]];
        UIImageView *iconView = [[UIImageView alloc]initWithImage:icon];
        iconView.bounds = CGRectMake(0, 0, 30, 42);
        maker.iconView = iconView;
        maker.position = CLLocationCoordinate2DMake(position.target.latitude+arc4random()%30/1000.0-0.003, position.target.longitude+arc4random()%30/1000.0-0.003);
        
        maker.map = self.mapView;
        [self.feedEntity_marker addObject:maker];
    }
    
}

#pragma mark-lazyload
- (NSMutableArray<GMSMarker *> *)feedEntity_marker
{
    if (_feedEntity_marker == nil) {
        _feedEntity_marker = [NSMutableArray new];
    }
    return _feedEntity_marker;
}

@end
