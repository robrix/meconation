//
//  RXAlertSheet.h
//  MecoNation
//
//  Created by Rob Rix on 8/31/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RXAlertSheet;
typedef void(^RXAlertSheetCompletionHandler)(RXAlertSheet *alertSheet, NSInteger selectedButtonIndex);

@interface RXAlertSheet : NSObject

+(instancetype)sheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles completionHandler:(RXAlertSheetCompletionHandler)completionHandler;

@property (nonatomic, copy, readonly) RXAlertSheetCompletionHandler completionHandler;

-(void)show;

@end
