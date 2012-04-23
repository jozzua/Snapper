//
//  ViewController.m
//  Snapper
//
//  Created by Elymar Apao on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import <Twitter/Twitter.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView;
@synthesize imgPicker;
@synthesize takePicButton;
@synthesize takeGalPicButton;
@synthesize priceField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self showPhotoMenu];

}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setImgPicker:nil];
    [self setTakePicButton:nil];
    [self setTakeGalPicButton:nil];
    [self setPriceField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)composeTweet
{

    TWTweetComposeViewController *tweetComposeViewController =
    [[TWTweetComposeViewController alloc] init];
//    [tweetComposeViewController setInitialText:@"#foodsnap"];
    [tweetComposeViewController addURL:[NSURL URLWithString:@"http://foodsnap.in"]];
    [tweetComposeViewController addImage:imageView.image];
    [tweetComposeViewController setCompletionHandler:
     ^(TWTweetComposeViewControllerResult result) {
         [self dismissModalViewControllerAnimated:YES];
     }];
    [self presentModalViewController:tweetComposeViewController animated:YES];
}


- (void)useCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        NSString *message = [NSString stringWithString:
                             @"Your device does not have a camera" ];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No camera available"
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }

        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker 
                                animated:YES];
        newMedia = YES;

}

-(void)takeLibraryImage
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = NO;
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {

        UIImage *image = [info 
                          objectForKey:UIImagePickerControllerEditedImage];
        

        NSString *myString = priceField.text;
        NSLog(@" The String is: %@",myString);
        
        UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
        [image drawAtPoint:CGPointZero];
        
        NSString *caption = myString;
        
        UIFont *captionFont = [UIFont boldSystemFontOfSize:36.0];
        [[UIColor blackColor] setFill]; // or setStroke? I am not sure.
        [caption drawAtPoint:CGPointMake(11.0f, 201.0f) withFont:captionFont];
        
        UIFont *captionFont2 = [UIFont boldSystemFontOfSize:36.0];
        [[UIColor whiteColor] setFill]; // or setStroke? I am not sure.
        [caption drawAtPoint:CGPointMake(10.0f, 200.0f) withFont:captionFont2];
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();        
        
        imageView.image = resultImage;
        
        
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(resultImage, 
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
    

}
-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error 
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)showPhotoMenu
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        
        [actionSheet showInView:self.view];
    } else {
        [self takeLibraryImage];
    }
}

- (void)actionSheet:(UIActionSheet *)theActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self useCamera];
    } else if (buttonIndex == 1) {
        [self takeLibraryImage];
    }
}


- (IBAction)takePic:(id)sender {
    
    [self useCamera];

}

- (IBAction)galPic:(id)sender {
    
    [self takeLibraryImage];

}

- (IBAction)tweeetThis:(id)sender {
    [self composeTweet];
}


-(IBAction)done

{
    
    NSLog(@"Contents of the text field: %@", self.priceField.text);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
