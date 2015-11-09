//
//  ViewController.m
//  WSFCam
//
//  Created by Christian Aranda on 6/11/15.
//  Copyright © 2015 WildStudio. All rights reserved.
//

#import "ViewController.h"
#import "WSCaptureSessionCoordinator.h"

@interface ViewController ()

@property (nonatomic, strong) WSCaptureSessionCoordinator *captureSessionCoordinator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;

@property (nonatomic, assign) BOOL recording;
@property (nonatomic, assign) BOOL dismissing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toggleRecording:(id)sender
{
    if(self.recording){
			[_captureSessionCoordinator stopRecording];
		}else{
			// Disable the idle timer while recording
			[UIApplication sharedApplication].idleTimerDisabled = YES;
				
			self.recordButton.enabled = NO; // re-enabled once recording has finished starting
			self.recordButton.title = @"Stop";
				
			[self.captureSessionCoordinator startRecording];
				
			_recording = YES;
		}
}


#pragma mark - Private methods

- (void)configureInterface
{
    AVCaptureVideoPreviewLayer *previewLayer = [_captureSessionCoordinator previewLayer];
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    [_captureSessionCoordinator startRunning];
}

- (void)stopPipelineAndDismiss
{
    [_captureSessionCoordinator stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
    _dismissing = NO;
}

- (void)checkPermissions
{
	/*
    IDPermissionsManager *pm = [IDPermissionsManager new];
    [pm checkCameraAuthorizationStatusWithBlock:^(BOOL granted) {
        if(!granted){
            NSLog(@"we don't have permission to use the camera");
        }
    }];
    [pm checkMicrophonePermissionsWithBlock:^(BOOL granted) {
        if(!granted){
            NSLog(@"we don't have permission to use the microphone");
        }
    }];
	 */
}

#pragma mark = IDCaptureSessionCoordinatorDelegate methods

- (void)coordinatorDidBeginRecording:(WSCaptureSessionCoordinator *)coordinator
{
    _recordButton.enabled = YES;
}

- (void)coordinator:(WSCaptureSessionCoordinator *)coordinator didFinishRecordingToOutputFileURL:(NSURL *)outputFileURL error:(NSError *)error
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    _recordButton.title = @"Record";
    _recording = NO;
    
    //Do something useful with the video file available at the outputFileURL
    //IDFileManager *fm = [IDFileManager new];
    //[fm copyFileToCameraRoll:outputFileURL];
    
    
    //Dismiss camera (when user taps cancel while camera is recording)
    if(_dismissing){
        [self stopPipelineAndDismiss];
    }
}

@end
