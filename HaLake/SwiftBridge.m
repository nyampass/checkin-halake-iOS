//
//  SwiftBridge.m
//  HaLake
//
//  Created by Tokusei Noborio on 2015/02/04.
//  Copyright (c) 2015年 Nyampass Corporation. All rights reserved.
//

#import "SwiftBridge.h"

@implementation SwiftBridge

+ (FUIAlertView *)createFUIAlertVIew:(NSString* )title message:(NSString *)message delegate:(id<FUIAlertViewDelegate>)delegate
        cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [[FUIAlertView alloc] initWithTitle:title message:message delegate:delegate
                             cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}

@end
