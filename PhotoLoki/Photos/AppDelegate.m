//
//  AppDelegate.m
//  Photos
//
//  Created by Melissa Boring on 4/30/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoCollectionViewController.h"
#import "PhotoViewController.h"

@interface AppDelegate() <UINavigationControllerDelegate>

@property (strong, nonatomic)UINavigationController *navigationController;
@property (nonatomic,retain)PhotoCollectionViewController *photoCollectionViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // self.window.tintColor = [UIColor colorWithRed:96.0/255.0 green:170.0/255.0 blue:219.0/255.0 alpha:1];
   // self.navigationController = (UINavigationController *)self.window.rootViewController;
   // self.photoCollectionViewController = self.navigationController.viewControllers[0];
    
    NSDictionary *defaults = @{@"AutoSavePhotoKey": [NSNumber numberWithBool:NO]};
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification object:[NSUserDefaults standardUserDefaults] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    
    return YES;
}



@end
