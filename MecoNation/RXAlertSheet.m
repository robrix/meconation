//
//  RXAlertSheet.m
//  MecoNation
//
//  Created by Rob Rix on 8/31/2013.
//  Copyright (c) 2013 Rob Rix. All rights reserved.
//

#import "RXAlertSheet.h"

@interface RXAlertSheet () <UIAlertViewDelegate>

@property (nonatomic) UIAlertView *alertView;

@property (nonatomic) id lifetimeHack;
@property (nonatomic) RXAlertSheetCompletionHandler completionHandler;

@end

@implementation RXAlertSheet

+(instancetype)sheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles completionHandler:(RXAlertSheetCompletionHandler)completionHandler {
	return [[self alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles completionHandler:completionHandler];
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles completionHandler:(RXAlertSheetCompletionHandler)completionHandler {
	if ((self = [super init])) {
		_alertView = [UIAlertView new];
		
		_alertView.title = title;
		_alertView.message = message;
		
		for (NSString *buttonTitle in otherButtonTitles) {
			[_alertView addButtonWithTitle:buttonTitle];
		}
		
		if (cancelButtonTitle) {
			_alertView.cancelButtonIndex = [_alertView addButtonWithTitle:cancelButtonTitle];
		}
		
		_alertView.delegate = self;
		
		_completionHandler = [completionHandler copy];
		_lifetimeHack = self;
	}
	return self;
}


-(void)show {
	[self.alertView show];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		self.completionHandler(self, buttonIndex);
	}
	self.completionHandler = nil;
	self.lifetimeHack = nil;
}

@end
