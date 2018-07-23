//
//  PublicGMSPaoPaoViewModel.m
//  GoogleMaps
//
//  Created by Mac on 2018/7/19.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//

#import "PublicGMSPaoPaoViewModel.h"

@interface PublicGMSPaoPaoViewModel ()

@property (nonnull,nonatomic,strong) UIView *infoWindow;

@property (nonnull,nonatomic,strong) UILabel *titleLabel;

@property (nonnull,nonatomic,strong) UIImageView *iconView;

@end

@implementation PublicGMSPaoPaoViewModel

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
    CGFloat height = textSize.height>self.iconView.image.size.height?textSize.height:self.iconView.image.size.height;
    height += 10;
    self.infoWindow.bounds = CGRectMake(0, 0, textSize.width+self.iconView.image.size.width+24, height);
    self.titleLabel.frame = CGRectMake(8, (height-textSize.height)/2.0, textSize.width, textSize.height);
    self.iconView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+8, self.titleLabel.center.y-self.iconView.image.size.height/2.0, self.iconView.image.size.width, self.iconView.image.size.height);
    return self.infoWindow;
}

- (UIView *)infoWindow
{
    if (_infoWindow == nil) {
        _infoWindow = [UIView new];
        _infoWindow.backgroundColor = UIColor.whiteColor;

        [_infoWindow addSubview:self.titleLabel];
        [_infoWindow addSubview:self.iconView];
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

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"issue_right_push"]];
    }
    return _iconView;
}

@end
