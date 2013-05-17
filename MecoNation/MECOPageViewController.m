//  MECOPageViewController.m
//  Created by Rob Rix on 2013-01-13.
//  Copyright (c) 2013 Micah Merswolke. All rights reserved.

#import "MECOPageViewController.h"

@interface MECOPageViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic) UISwipeGestureRecognizer *left;
@property (nonatomic) UISwipeGestureRecognizer *right;

@property (nonatomic, getter = isAdvancingToNextPage) bool advancingToNextPage;
@property (nonatomic, getter = isReturningToPreviousPage) bool returningToPreviousPage;

@property (nonatomic) UIViewController *nextViewController;
@property (nonatomic) UIViewController *previousViewController;
@end

@implementation MECOPageViewController

@dynamic view;

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage)];
	self.left.direction = UISwipeGestureRecognizerDirectionLeft;
	self.left.delegate = self;
	[self.view addGestureRecognizer:self.left];
	[self.view.panGestureRecognizer requireGestureRecognizerToFail:self.left];
	
	self.right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousPage)];
	self.right.direction = UISwipeGestureRecognizerDirectionRight;
	self.right.delegate = self;
	[self.view addGestureRecognizer:self.right];
	[self.view.panGestureRecognizer requireGestureRecognizerToFail:self.right];
}

-(void)nextPage {
	self.advancingToNextPage = YES;
	
	self.currentViewController.view.center = (CGPoint){
		self.currentViewController.view.center.x - CGRectGetWidth(self.currentViewController.view.bounds),
		self.currentViewController.view.center.y
	};
	[self.currentViewController willMoveToParentViewController:nil];
	
	self.view.contentSize = self.nextViewController.view.bounds.size;
	self.nextViewController.view.frame = (CGRect){ .size = self.view.contentSize };
	[self.view addSubview:self.nextViewController.view];
	[self addChildViewController:self.nextViewController];
	
	[self.view setContentOffset:(CGPoint){ -CGRectGetWidth(self.view.bounds), 0 } animated:NO];
	[self.view setContentOffset:CGPointZero animated:YES];
}

-(void)previousPage {
	self.returningToPreviousPage = YES;
	
	self.currentViewController.view.center = (CGPoint){
		self.currentViewController.view.center.x + CGRectGetWidth(self.currentViewController.view.bounds),
		self.currentViewController.view.center.y
	};
	[self.currentViewController willMoveToParentViewController:nil];
	
	self.view.contentSize = self.previousViewController.view.bounds.size;
	self.previousViewController.view.frame = (CGRect){ .size = self.view.contentSize };
	[self.view addSubview:self.previousViewController.view];
	[self addChildViewController:self.previousViewController];
	
	[self.view setContentOffset:(CGPoint){ self.view.contentSize.width, 0 } animated:NO];
	[self.view setContentOffset:(CGPoint){ self.view.contentSize.width - self.view.bounds.size.width, 0 } animated:YES];
}


-(void)setCurrentViewController:(UIViewController *)currentViewController {
	[self.currentViewController willMoveToParentViewController:nil];
	[self.currentViewController removeFromParentViewController];
	[self.currentViewController.view removeFromSuperview];
	
	_currentViewController = currentViewController;
	
	[self.view addSubview:self.currentViewController.view];
	self.view.contentSize = self.currentViewController.view.bounds.size;
	[self addChildViewController:self.currentViewController];
	[self.currentViewController didMoveToParentViewController:self];
	
	self.nextViewController = [self.dataSource pageViewController:self viewControllerAfterViewController:self.currentViewController];
	self.previousViewController = [self.dataSource pageViewController:self viewControllerBeforeViewController:self.currentViewController];
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	if (self.isAdvancingToNextPage) {
		self.advancingToNextPage = NO;
		self.previousViewController = self.currentViewController;
		[self.currentViewController removeFromParentViewController];
		[self.currentViewController.view removeFromSuperview];
		_currentViewController = self.nextViewController;
		[self.currentViewController didMoveToParentViewController:self];
		self.nextViewController = [self.dataSource pageViewController:self viewControllerAfterViewController:self.currentViewController];
	} else if (self.isReturningToPreviousPage) {
		self.returningToPreviousPage = NO;
		self.nextViewController = self.currentViewController;
		[self.currentViewController removeFromParentViewController];
		[self.currentViewController.view removeFromSuperview];
		_currentViewController = self.previousViewController;
		[self.currentViewController didMoveToParentViewController:self];
		self.previousViewController = [self.dataSource pageViewController:self viewControllerBeforeViewController:self.currentViewController];
	}
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	bool isAtRight = (self.view.contentOffset.x >= (self.view.contentSize.width - CGRectGetWidth(self.view.bounds)));
	bool isAtLeft = (self.view.contentOffset.x <= 0);
	bool isLeft = (gestureRecognizer == self.left);
	bool isRight = (gestureRecognizer == self.right);
	return (isLeft && isAtRight && self.nextViewController) || (isRight && isAtLeft && self.previousViewController);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

@end
