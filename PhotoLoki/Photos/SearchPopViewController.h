//
//  SearchViewController.h
//  Photos
//
//  Created by Melissa Boring on 5/19/14.
//  Copyright (c) 2014 Melissa Boring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchLocation.h"
#import "Photo.h"

@class SearchPopViewController;

@protocol SearchViewControllerDelegate <NSObject>
- (void)searchViewControllerDidLocatePhoto:(Photo *)photo;
@end

@interface SearchPopViewController : UIViewController <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, weak) id <SearchViewControllerDelegate> delegate;
@property (nonatomic,strong) Photo *searchPhoto;
@end

