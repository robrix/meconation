//
//  MECOWorldController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-31.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOIslandViewController.h"
#import "MECOWorldViewController.h"
#import "MECOPageViewController.h"
#import "MECOIsland.h"

@interface MECOWorldViewController () <MECOPageViewControllerDataSource, MECOPageViewControllerDelegate>

@property (copy) NSArray *islands;

@property (strong) IBOutlet UIToolbar *toolbar;
@property (strong) IBOutlet UIBarButtonItem *islandIdentifier;
@property (nonatomic, strong) MECOPageViewController *pageViewController;

@property (copy) NSArray *islandViewControllers;

@end

@implementation MECOWorldViewController

@synthesize islands = _islands;
@synthesize pageViewController = _pageViewController;


-(NSUInteger) currentIslandNumber{
    return self.currentIslandViewController.islandIndex + 1;
}
-(NSString*) currentIslandLabel{
    return [NSString stringWithFormat: @"Island %u", self.currentIslandNumber];
}
-(void) updateIslandLabel{
    self.islandIdentifier.title = self.currentIslandLabel;
}

-(MECOIslandViewController *)createViewControllerForIslandAtIndex:(NSUInteger)index {
	MECOIslandViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"islandViewController"];
	controller.view.frame = self.pageViewController.view.bounds;
	controller.island = [[MECOIsland allIslands] objectAtIndex:index];
	controller.islandIndex = index;
	return controller;
}

-(void)viewDidLoad {
	self.toolbar.frame = (CGRect){
		.size = { self.view.bounds.size.width, 30 }
	};
	
	[self performSegueWithIdentifier:@"pageViewController" sender:self];
	
	NSMutableArray *islandViewControllers = [NSMutableArray new];
	NSUInteger islandIndex = 0;
	for (MECOIsland *island in [MECOIsland allIslands]) {
		MECOIslandViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"islandViewController"];
		controller.view.frame = self.pageViewController.view.bounds;
		controller.island = island;
		controller.islandIndex = islandIndex++;
		[islandViewControllers addObject:controller];
	}
	self.islandViewControllers = islandViewControllers;
	
	self.pageViewController.currentViewController = [self.islandViewControllers objectAtIndex:0];
}


-(MECOIslandViewController *)currentIslandViewController {
	return (MECOIslandViewController *)self.pageViewController.currentViewController;
}


-(IBAction)addMeco:(id)sender {
	[self.currentIslandViewController addMeco:sender];
}

-(IBAction)showJobsMenu:(id)sender {
	[self.currentIslandViewController showJobsMenu:sender];
}


-(void)setPageViewController:(MECOPageViewController *)pageViewController {
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


-(MECOIslandViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerAfterViewController:(MECOIslandViewController *)viewController {
	return viewController.islandIndex < (self.islandViewControllers.count - 1)?
		[self.islandViewControllers objectAtIndex:viewController.islandIndex + 1]
	:	nil;
}

-(MECOIslandViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerBeforeViewController:(MECOIslandViewController *)viewController {
	return viewController.islandIndex > 0?
		[self.islandViewControllers objectAtIndex:viewController.islandIndex - 1]
	:	nil;
}


-(void)pageViewController:(MECOPageViewController *)pageViewController didShowViewController:(UIViewController *)controller {
	// update the island number bar button item here
}

@end
