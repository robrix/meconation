//
//  MECOWorldController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-31.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOIslandViewController.h"
#import "MECOWorldViewController.h"
#import "MECOIsland.h"

@interface MECOWorldViewController () <UIPageViewControllerDataSource>

@property (copy) NSArray *islands;

@property (strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation MECOWorldViewController

@synthesize islands = _islands;
@synthesize pageViewController = _pageViewController;


-(MECOIslandViewController *)createViewControllerForIslandAtIndex:(NSUInteger)index {
	MECOIslandViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"islandViewController"];
	controller.view.frame = self.pageViewController.view.bounds;
	controller.island = [self.islands objectAtIndex:index];
	controller.islandIndex = index;
	return controller;
}

-(void)viewDidLoad {
	self.islands = [NSArray arrayWithObjects:[MECOIsland firstIsland], [MECOIsland firstIsland], nil];
	
	self.toolbar.frame = (CGRect){
		.size = { self.view.bounds.size.width, 30 }
	};
	
	[self performSegueWithIdentifier:@"pageViewController" sender:self];
	
	[self.pageViewController setViewControllers:[NSArray arrayWithObject:[self createViewControllerForIslandAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
//	NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey:UITextAttributeFont];
//	for (UIBarItem *item in self.toolbar.items) {
//		[item setTitleTextAttributes:attributes forState:UIControlStateNormal];
//	}
}


-(void)setPageViewController:(UIPageViewController *)pageViewController {
	_pageViewController = pageViewController;
	
	pageViewController.dataSource = self;
	
	[self addChildViewController:pageViewController];
	
	const CGFloat kToolbarHeight = CGRectGetHeight(self.toolbar.bounds);
	pageViewController.view.frame = (CGRect){
		{0, kToolbarHeight},
		{CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kToolbarHeight}
	};
	[self.view addSubview:pageViewController.view];
	
	[pageViewController didMoveToParentViewController:self];
}




-(MECOIslandViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(MECOIslandViewController *)viewController {
	return viewController.islandIndex < (self.islands.count - 1)?
		[self createViewControllerForIslandAtIndex:viewController.islandIndex + 1]
	:	nil;
}

-(MECOIslandViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(MECOIslandViewController *)viewController {
	return viewController.islandIndex > 0?
		[self createViewControllerForIslandAtIndex:viewController.islandIndex - 1]
	:	nil;
}

@end
