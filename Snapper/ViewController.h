//
//  ViewController.h
//  Snapper
//
//  Created by Elymar Apao on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController : UIViewController <UINavigationControllerDelegate,
    UIImagePickerControllerDelegate>
{
    UIImageView *imageView;
    BOOL newMedia;

}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (strong, nonatomic) IBOutlet UIButton *takePicButton;
@property (strong, nonatomic) IBOutlet UIButton *takeGalPicButton;



- (IBAction)takePic:(id)sender;
- (IBAction)galPic:(id)sender;


@end
