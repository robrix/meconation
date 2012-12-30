//
//  RXOptionSheet.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-30.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "RXOptionSheet.h"

@interface RXOptionSheet () <UIActionSheetDelegate>

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSArray *options;
@property (nonatomic, getter = isCancellable, readwrite) bool cancellable;
@property (nonatomic, copy, readwrite) RXOptionSheetCompletionHandler completionHandler;

@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, strong) id lifetimeHack;

@end

@implementation RXOptionSheet

@synthesize title = _title;
@synthesize options = _options;
@synthesize cancellable = _cancellable;
@synthesize completionHandler = _completionHandler;
@synthesize actionSheet = _actionSheet;
@synthesize lifetimeHack = _lifetimeHack;

+(RXOptionSheet *)sheetWithTitle:(NSString *)title options:(NSArray *)options optionTitleKeyPath:(NSString *)keyPath cancellable:(bool)cancellable completionHandler:(RXOptionSheetCompletionHandler)completionHandler {
	RXOptionSheet *sheet = [self new];
	sheet.title = title;
	sheet.options = options;
	sheet.cancellable = cancellable;
	sheet.completionHandler = completionHandler;
	
	sheet.lifetimeHack = sheet;
	
	sheet.actionSheet = [UIActionSheet new];
	sheet.actionSheet.title = title;
	sheet.actionSheet.delegate = sheet;
	for (NSString *option in options) {
		[sheet.actionSheet addButtonWithTitle:[option valueForKey:keyPath]];
	}
	
	if (cancellable) {
		[sheet.actionSheet addButtonWithTitle:@"Cancel"];
		sheet.actionSheet.cancelButtonIndex = sheet.actionSheet.numberOfButtons - 1;
	}
	
	return sheet;
}

-(void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(bool)animated {
	[self.actionSheet showFromRect:rect inView:view animated:animated];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		self.completionHandler(self, [self.options objectAtIndex:buttonIndex]);
	}
	self.completionHandler = nil;
	self.lifetimeHack = nil;
}

@end
