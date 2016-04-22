//
//  FXJAppDelegate.h
//  FXJReactiveCocoa
//
//  Created by myApplePro01 on 16/4/22.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import "FXJAppDelegate.h"
#import "FXJViewController.h"

@interface FXJAppDelegate ()

@property (nonatomic, retain) UINavigationController *navigationController;


@end

@implementation FXJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // create a navigation controller and perform some simple styling
  self.navigationController = [UINavigationController new];
  self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
  
  // create and navigate to a view controller
  UIViewController *viewController = [[FXJViewController alloc] init];
  [self.navigationController pushViewController:viewController animated:NO];

  // show the navigation controller
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
