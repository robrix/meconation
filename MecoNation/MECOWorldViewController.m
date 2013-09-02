//
//  MECOWorldController.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-31.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOGameController.h"
#import "MECOIslandViewController.h"
#import "MECOWorldViewController.h"
#import "MECOPageViewController.h"
#import "MECOIsland.h"
#import "MECOJob.h"
#import "MECOPerson.h"
#import "MECOResource.h"
#import "MECOViewUtilities.h"
#import "MECOAnimal.h"

#import "RXOptionSheet.h"
#import "RXAlertSheet.h"

@interface MECOWorldViewController () <MECOPageViewControllerDataSource, MECOPageViewControllerDelegate>

@property (strong) IBOutlet UIButton *boatButton;
@property (strong) IBOutlet UILabel *warningLabel;
@property (strong) IBOutlet UIToolbar *toolbar;
@property (strong) IBOutlet UILabel *islandIdentifier;
@property (strong) IBOutlet UILabel *IQCount;
@property (strong) IBOutlet UILabel *woodCount;
@property (strong) IBOutlet UILabel *stoneCount;
@property (strong) IBOutlet UILabel *foodCount;
@property (strong) IBOutlet UILabel *leafCount;
@property (strong) IBOutlet UILabel *leatherCount;
@property (strong) IBOutlet UILabel *goldCount;
@property (strong) IBOutlet UILabel *woolCount;
@property (strong) IBOutlet UILabel *furCount;
@property (nonatomic, strong) MECOPageViewController *pageViewController;

@property (copy) NSArray *islandViewControllers;

@property (strong) IBOutlet UILabel *mecoPopulationLabel;
@property (nonatomic, copy) NSDictionary *labelsByResourceName;

@property (nonatomic) MECOGameController *gameController;

@property (nonatomic) id resourceDidChangeObserver;

@end

@implementation MECOWorldViewController

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self.resourceDidChangeObserver];
}

@synthesize pageViewController = _pageViewController;

// Labels the current Island
-(NSUInteger)currentIslandNumber {
	return self.currentIslandViewController.islandIndex + 1;
}
-(NSString *)currentIslandLabel {
	return [NSString stringWithFormat: @"%u", self.currentIslandNumber];
}
-(void)updateIslandLabel {
	self.islandIdentifier.text = self.currentIslandLabel;
	[self.islandIdentifier sizeToFit];
}


//Warning Label updates
-(void) updateWarningLabelForSheep {
	[self updateWarningLabelWithText:@"Sorry Sheep are unavailable right now..."];
}
-(void) updateWarningLabelForPopulation{
	[self updateWarningLabelWithText:@"You will need another house for that..."];
}
-(void) updateWarningLabelForJobs{
	[self updateWarningLabelWithText:@"You don't have a Tailor to make any uniforms, on this island..."];
}
-(void) updateWarningLabelForIQ {
	[self updateWarningLabelWithText:@"You will need more IQ to do that"];
}

-(void)updateWarningLabelWithText:(NSString *)text {
	self.warningLabel.text = text;
	MECOFadeInView(self.warningLabel, self.view);
	MECOFadeOutView(self.warningLabel, 3);
}


//Population Label stuff
-(NSString *)populationLabel {
	return [NSString stringWithFormat: @"%u / %u / %u", self.currentIslandPopulation, self.world.currentPopulation, self.world.maximumPopulation];
}
-(void)updatePopulationLabel {
	self.mecoPopulationLabel.text = self.populationLabel;
	[self.mecoPopulationLabel sizeToFit];
}
-(NSUInteger) currentIslandPopulation {
	return self.currentIsland.mecos.count;
}


-(void)updateLabel:(UILabel *)label withResource:(MECOResource *)resource {
	label.text = [NSString stringWithFormat:@"%g", resource.quantity];
	[label sizeToFit];
}


-(void)viewDidLoad {
	self.toolbar.frame = (CGRect){
		.size = { self.view.bounds.size.width, 30 }
	};
	
	self.resourceDidChangeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:MECOResourceDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		MECOResource *resource = note.object;
		[self updateLabel:self.labelsByResourceName[resource.name] withResource:resource];
	}];
	
	self.labelsByResourceName = @{
								  @"food": self.foodCount,
								  @"leaf": self.leafCount,
								  @"leather": self.leatherCount,
								  @"gold": self.goldCount,
								  @"fur": self.furCount,
								  @"IQ": self.IQCount,
								  @"stone": self.stoneCount,
								  @"wood": self.woodCount,
								  @"wool": self.woolCount,
								  };
	
	self.gameController = [[MECOGameController alloc] init];
	self.gameController.world = self.world = [MECOWorld new];
	
	[self performSegueWithIdentifier:@"pageViewController" sender:self];
	
	NSMutableArray *islandViewControllers = [NSMutableArray new];
	NSUInteger islandIndex = 0;
	for (MECOIsland *island in self.world.islands) {
		MECOIslandViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"islandViewController"];
		controller.view.frame = self.pageViewController.view.bounds;
		
		[controller configureWithIslandAtIndex:islandIndex++ inWorld:self.world];
		
		[self.gameController addActorsObject:controller];
		
		controller.worldViewController = self;
		[islandViewControllers addObject:controller];
	}
	self.islandViewControllers = islandViewControllers;
	
	self.pageViewController.currentViewController = self.islandViewControllers[0];
	
	self.gameController.paused = NO;
}


-(MECOIsland *)currentIsland {
	return self.currentIslandViewController.island;
}

-(MECOIslandViewController *)currentIslandViewController {
	return (MECOIslandViewController *)self.pageViewController.currentViewController;
}


#pragma mark Build menu

-(NSArray *)buildables{
	return @[@"House"];
}
-(IBAction)showBuildMenu:(id)sender{
	RXOptionSheet *buildableSheet = [RXOptionSheet sheetWithTitle:@"Build" options:[self buildables] optionTitleKeyPath:@"self" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, id selectedOption) {
		if ([selectedOption isEqual:@"House"]){
			//Build a house
		}
	}];
	[buildableSheet showFromRect:self.view.bounds inView:self.view animated:YES];
}

#pragma mark Spawn menu

-(IBAction)addMeco:(id)sender {
	if (self.world.currentPopulation < self.world.maximumPopulation) {
		[self addMecoWithJob:nil];
	} else {
		[self updateWarningLabelForPopulation];
	}
}

-(void)addMecoWithJob:(MECOJob *)job {
	MECOPerson *meco = [MECOPerson personWithName:[MECOPerson randomName] job:job];
	[self.currentIsland addPerson:meco];
}

-(NSArray *)spawnables{
	return @[@"Sheep", @"Meco"];
}
-(IBAction)showSpawnMenu:(id)sender {
	RXOptionSheet *spawnsheet = [RXOptionSheet sheetWithTitle:@"Spawn?" options:self.world.spawnables optionTitleKeyPath:@"name" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOAnimal *animal) {
		
	}];
	[spawnsheet showFromRect:self.view.bounds inView:self.view animated:YES];
}

-(IBAction)spawnMeco:(id)sender{
	if (self.world.IQResource.quantity >= 100)
	{
		[self addMeco:nil];
		[self updatePopulationLabel];
		self.world.IQResource.quantity -= 100;
	}
	else
	{
		[self updateWarningLabelForIQ];
	}
}

#pragma mark Boat menu

-(IBAction)showBoatMenu:(id)sender{
	NSArray *mecos = [self.currentIsland.mecos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];	
	RXOptionSheet *boatSheet = [RXOptionSheet sheetWithTitle:@"Choose a meco to move:" options:mecos optionTitleKeyPath:@"name" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOPerson *selectedMeco) {
		[self showIslandMenuForMeco:selectedMeco];
	}];
	[boatSheet showFromRect:self.view.bounds inView:self.view animated:YES];
}
-(void) showIslandMenuForMeco:(MECOPerson *)meco {
	RXOptionSheet *mecoBoatSheet = [RXOptionSheet sheetWithTitle:@"Move to:" options:self.world.islands optionTitleKeyPath:@"name" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, id selectedOption) {
		
	}];
	[mecoBoatSheet showFromRect:self.view.bounds inView:self.view animated:YES];
}

#pragma mark Job menu

-(void)showMecosMenuForJob:(MECOJob *)job {
	NSArray *mecos = [self.currentIsland.mecos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	
	RXOptionSheet *optionSheet = [RXOptionSheet sheetWithTitle:[NSString stringWithFormat:@"Select a Meco to make a %@", job.title] options:mecos optionTitleKeyPath:@"label" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOPerson *meco) {
		[self showFireWarningForMeco:meco assigningJob:job];
	}];
	[optionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
}

-(IBAction)showJobsMenu:(id)sender {
	NSArray *mecos = [self.currentIsland.mecos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	bool foundATailor = NO;
	for (MECOPerson *meco in mecos) {
		if ([meco.job isEqual:(self.world.jobsByTitle[MECOTailorJobTitle])]) {
			RXOptionSheet *optionSheet = [RXOptionSheet sheetWithTitle:@"Jobs" options:self.world.jobs optionTitleKeyPath:@"title" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOJob *selectedJob) {
				[self showMecosMenuForJob:selectedJob];
			}];
			
			[optionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
			foundATailor = YES;
			break;
		}
	}
	if (foundATailor == NO) {
		[self updateWarningLabelForJobs];
	}
}

-(void) showFireWarningForMeco: (MECOPerson*) selectedMeco assigningJob:(MECOJob*)job {
	
	NSArray *worldMecos = [self.world.allMecos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	int likeJobsFound = 0;
	for (MECOPerson *meco in worldMecos) {
		if ([meco.job isEqual:selectedMeco.job]) {
			likeJobsFound += 1;
		}
	}
	if (likeJobsFound == 1) {
		RXAlertSheet *alertSheet = [RXAlertSheet sheetWithTitle:@"Are you sure?" message:[NSString stringWithFormat:@"Changing the occupation of your last %@ may send your civilisation's economy plummeting!", selectedMeco.job.title] cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Continue"] completionHandler:^(RXAlertSheet *alertSheet, NSInteger selectedButtonIndex) {
			selectedMeco.job = job;
		}];
		[alertSheet show];
	}
	else {
		selectedMeco.job = job;
	}
}

-(IBAction)showFireMenu:(id)sender {
	NSArray *mecos = [self.currentIsland.mecos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	RXOptionSheet *optionSheet = [RXOptionSheet sheetWithTitle:[NSString stringWithFormat:@"Select a Meco to fire"] options:mecos optionTitleKeyPath:@"label" cancellable:YES completionHandler:^(RXOptionSheet *optionSheet, MECOPerson *meco) {
		[self showFireWarningForMeco:meco assigningJob:nil];
	}];
	[optionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
}


-(void)setPageViewController:(MECOPageViewController *)pageViewController {
	_pageViewController = pageViewController;
	
	pageViewController.delegate = self;
	pageViewController.dataSource = self;
	
	[self addChildViewController:pageViewController];
	
	const CGFloat kToolbarHeight = CGRectGetHeight(self.toolbar.bounds);
	pageViewController.view.frame = (CGRect){
		{0, kToolbarHeight},
		{CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - kToolbarHeight}
	};
	[self.view insertSubview:pageViewController.view atIndex:1];
	
	[pageViewController didMoveToParentViewController:self];
}


-(MECOIslandViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerAfterViewController:(MECOIslandViewController *)viewController {
	return viewController.islandIndex < (self.islandViewControllers.count - 1)?
		self.islandViewControllers[viewController.islandIndex + 1]
	:	nil;
}

-(MECOIslandViewController *)pageViewController:(MECOPageViewController *)pageViewController viewControllerBeforeViewController:(MECOIslandViewController *)viewController {
	return viewController.islandIndex > 0?
		self.islandViewControllers[viewController.islandIndex - 1]
	:	nil;
}


-(void)pageViewController:(MECOPageViewController *)pageViewController didShowViewController:(UIViewController *)controller {
	[self updateIslandLabel];
	[self updatePopulationLabel];
}

@end
