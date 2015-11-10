//
//  ViewController.m
//  WSFCam
//
//  Created by Christian Aranda on 6/11/15.
//  Copyright © 2015 WildStudio. All rights reserved.
//

#import "ViewController.h"
#import "WSCaptureSessionViewController.h"


@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	
    // Dispose of any resources that can be recreated.
}
- (IBAction)toggleRecording:(id)sender
{
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	WSCaptureSessionViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"captureSessionVC"];
	[self presentViewController:viewController animated:YES completion:nil];
}


@end
