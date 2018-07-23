//
//  PublicGMSRetrieveViewModel.m
//  GoogleMaps
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//

#import "PublicGMSRetrieveViewModel.h"

@interface PublicGMSRetrieveViewModel ()

@property (nonnull,nonatomic,strong) UIView *infoWindow;

@property (nonnull,nonatomic,strong) UILabel *titleLabel;

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
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{    [super mapView:mapView idleAtCameraPosition:position];
    
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

- (UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker
{
    if (marker.title.length == 0) {
        return nil;
    }
    if ([marker.title isEqualToString:self.titleLabel.text]) {
        return self.infoWindow;
    }
    
    self.titleLabel.text = marker.title;
    
    CGSize textSize = [marker.title boundingRectWithSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width*3/4, UIScreen.mainScreen.bounds.size.height/3) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    CGFloat height = textSize.height + 10;
    self.infoWindow.bounds = CGRectMake(0, 0, textSize.width+10, height);
    self.titleLabel.frame = CGRectMake(5, (height-textSize.height)/2.0, textSize.width, textSize.height);
    return self.infoWindow;
}

#pragma mark-lazyload
- (NSMutableArray<GMSMarker *> *)feedEntity_marker
{
    if (_feedEntity_marker == nil) {
        _feedEntity_marker = [NSMutableArray new];
    }
    return _feedEntity_marker;
}

- (UIView *)infoWindow
{
    if (_infoWindow == nil) {
        _infoWindow = [UIView new];
        _infoWindow.backgroundColor = UIColor.whiteColor;
        
        [_infoWindow addSubview:self.titleLabel];
    }
    return _infoWindow;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = UIColor.blackColor;
    }
    return _titleLabel;
}

@end
