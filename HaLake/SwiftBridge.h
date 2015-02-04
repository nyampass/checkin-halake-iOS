//
//  SwiftBridge.h
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/04.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlatUIKIt.h"

@interface SwiftBridge : NSObject

+ (FUIAlertView *)createFUIAlertVIew:(NSString* )title message:(NSString *)message delegate:(id<FUIAlertViewDelegate>)delegate
        cancelButtonTitle:(NSString *)cancelButtonTitle;

@end
