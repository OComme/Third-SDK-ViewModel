//
//  ViewController.m
//  GoogleMaps
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "PublicGMSPositionViewModel.h"
#import "PublicGMSRetrieveViewModel.h"
#import "PublicGMSPaoPaoViewModel.h"

@interface ViewController ()<GMSMapViewDelegate,PublicGMSViewModelProtocol>

@property (nonnull,nonatomic,strong) GMSMapView *mapView;

@property (nonnull,nonatomic,strong) PublicGMSPaoPaoViewModel *vm_map;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     地图初始化
     **/
    _mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    _mapView.delegate = self;
    _mapView.indoorEnabled = NO;
    _mapView.settings.rotateGestures = NO;
    _mapView.settings.tiltGestures = NO;
//    _mapView.settings.myLocationButton = YES;
//    _mapView.myLocationEnabled = YES;
    

    [self.view addSubview:_mapView];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6.0];
    self.mapView.camera = camera;
    
    self.vm_map.mapView = self.mapView;
    self.vm_map.delegate = self;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"定位" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.bounds = CGRectMake(0, 0, 40, 40);
    btn.center = self.view.center;
    
    [btn addTarget:self.vm_map action:@selector(locateToUserLocation) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark-PublicGMSViewModelProtocol
- (void)gms_outPutAddressInfo:(PublicGMSAddressDataModel *)addressModel
{

}

#pragma mark-lazyload
- (PublicGMSPaoPaoViewModel *)vm_map
{
    if (_vm_map == nil){
        _vm_map = [PublicGMSPaoPaoViewModel new];
    }
    return _vm_map;
}

@end
