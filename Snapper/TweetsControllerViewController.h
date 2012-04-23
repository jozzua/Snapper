//
//  TweetsControllerViewController.h
//  Snapper
//
//  Created by Elymar Apao on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsControllerViewController : UITableViewController



@property (nonatomic, copy) NSString *query;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *buffer;
@property (nonatomic, retain) NSMutableArray *results;
- (IBAction)Refresh:(id)sender;


@end
