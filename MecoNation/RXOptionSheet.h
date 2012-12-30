//
//  RXOptionSheet.h
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXOptionSheet;
typedef void(^RXOptionSheetCompletionHandler)(RXOptionSheet *optionSheet, id selectedOption);

@interface RXOptionSheet : NSObject

+(RXOptionSheet *)sheetWithTitle:(NSString *)title options:(NSArray *)options optionTitleKeyPath:(NSString *)keyPath cancellable:(bool)cancellable completionHandler:(RXOptionSheetCompletionHandler)completionHandler;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray *options;
@property (nonatomic, getter = isCancellable, readonly) bool cancellable;
@property (nonatomic, copy, readonly) RXOptionSheetCompletionHandler completionHandler;

-(void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(bool)animated;

@end
