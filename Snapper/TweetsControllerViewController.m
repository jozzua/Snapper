//
//  TweetsControllerViewController.m
//  Snapper
//
//  Created by Elymar Apao on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetsControllerViewController.h"
#import "SBJSON.h"

@interface TweetsControllerViewController ()

- (void)loadQuery;
- (void)handleError:(NSError *)error;
@end

@implementation TweetsControllerViewController
@synthesize query=_query;
@synthesize connection=_connection;
@synthesize buffer=_buffer;
@synthesize results=_results;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.query;
    [self loadQuery];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self.connection cancel];
    
    self.connection = nil;
    self.buffer = nil;
    self.results = nil;
}

- (void)dealloc
{
    [self.connection cancel];
    [_connection release];
    [_buffer release];
    [_results release];
    [_query release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark === UITableViewDataSource Delegates ===
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = [self.results count];
    return count > 0 ? count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ResultCellIdentifier = @"ResultCell";
    static NSString *LoadCellIdentifier = @"LoadingCell";
    
    NSUInteger count = [self.results count];
    if ((count == 0) && (indexPath.row == 0)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:LoadCellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
        
        if (self.connection) {
            cell.textLabel.text = @"Loading...";
        } else {
            cell.textLabel.text = @"Not available";
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:ResultCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        
        
    }
    
    NSDictionary *tweet = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [tweet objectForKey:@"from_user"],
                           [tweet objectForKey:@"text"]];
    
    cell.textLabel.text = [tweet objectForKey:@"text"];  
    cell.textLabel.adjustsFontSizeToFitWidth = YES;  
    cell.textLabel.font = [UIFont systemFontOfSize:12];  
    cell.textLabel.numberOfLines = 4;  
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;  
    
    
    
    
    NSDictionary *entity = [tweet objectForKey:@"entities"];
    NSArray *media = [entity objectForKey:@"media"];
    NSDictionary *firstObj = [media objectAtIndex:0];
    NSDictionary *media_url = [firstObj objectForKey:@"media_url"];
    
    NSString *mediaUrlString = [NSString stringWithFormat: @"%@:thumb", media_url];
    
    
    
    //    NSLog(@"Tweet: %@",tweet);
    
    
    
    NSURL *url = [NSURL URLWithString:mediaUrlString];  
    
    NSLog(@"Image: %@",mediaUrlString);
    
    NSData *data = [NSData dataWithContentsOfURL:url];  
    cell.imageView.image = [UIImage imageWithData:data];  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  
    
    
    return cell;
}







- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row & 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark -
#pragma mark === Private methods ===
#pragma mark -

#define RESULTS_PERPAGE 100

- (void)loadQuery {
    
    
    
    NSString *path = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=pic.twitter.com foodsnap.in&lang=en&rpp=100&include_entities=true"];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.buffer = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    
    NSString *jsonString = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
    NSDictionary *jsonResults = [jsonString JSONValue];
    self.results = [jsonResults objectForKey:@"results"];
    
    
    
    [jsonString release];
    self.buffer = nil;
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    self.buffer = nil;
    
    [self handleError:error];
    [self.tableView reloadData];
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error"                              
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


- (IBAction)Refresh:(id)sender {
    [self loadQuery];
}
@end
