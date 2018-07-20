//
//  PublicGMSFetchModel.m
//  GoogleMaps
//
//  Created by Mac on 2018/7/20.
//  Copyright © 2018年 Shenzhen LvPai Culture Communication Co., Ltd. All rights reserved.
//

#import "PublicGMSFetchModel.h"

@implementation PublicGMSFetchModel

- (void)filteredResponseData:(NSData *)Data withSucceed:(PTFetchBlock)succeed Failed:(PTFetchBlock)failed {
    if (Data == nil) {
        if (self.failed) {
            self.failed(@"数据异常");
        }
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:nil];
    if (dict == nil || [dict isKindOfClass: [NSDictionary class]] == NO || dict[@"results"] == nil || [dict[@"results"] count] == 0) {
        if (self.failed) {
            self.failed(@"数据异常");
        }
        return;
    }
    if ([dict[@"status"]isEqualToString:@"OK"] == NO) {
        if (self.failed) {
            self.failed(dict[@"error_message"]);
        }
        return;
    }
    
    if (self.succeed) {
        self.succeed(dict);
    }
}

- (id)mapErrorData:(id)error {
    return error;
}

- (NSDictionary *)paramentByAppendingParament:(NSDictionary *)parament {
    return parament;
}

- (NSString *)urlByAppendingUrl:(NSString *)url {
    return url;
}

@end
