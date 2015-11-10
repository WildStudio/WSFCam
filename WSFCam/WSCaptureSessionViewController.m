//
//  WSCaptureSessionViewController.m
//  WSFCam
//
//  Created by Alma IT on 10/11/15.
//  Copyright © 2015 WildStudio. All rights reserved.
//

#import "WSCaptureSessionViewController.h"
#import "WSCaptureSessionCoordinator.h"
#import "WSCaptureSessionMovieFileOutputCoordinator.h"
#import "WSFileManager.h"
#import "WSPermissionManager.h"

@interface WSCaptureSessionViewController () <WSCaptureSessionCoordinatorDelegate>

@property (nonatomic, strong) WSCaptureSessionCoordinator *captureSessionCoordinator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;

@property (nonatomic, assign) BOOL recording;
@property (nonatomic, assign) BOOL dismissing;


@end

@implementation WSCaptureSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	 _captureSessionCoordinator = [[WSCaptureSessionMovieFileOutputCoordinator alloc] init];
	
	[_captureSessionCoordinator setDelegate:self callbackQueue:dispatch_get_main_queue()];
	[self configureInterface];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toggleRecording:(id)sender
{
	if(self.recording){
		[self.captureSessionCoordinator stopRecording];
	}else{
		// Disable the idle timer while recording
		[UIApplication sharedApplication].idleTimerDisabled = YES;
		
		self.recordButton.enabled = NO; // re-enabled once recording has finished starting
		self.recordButton.title = @"Stop";
		
		[self.captureSessionCoordinator startRecording];
		
		self.recording = YES;
	}
}

- (IBAction)closeCamera:(id)sender
{
	//TODO: tear down pipeline
	if(_recording){
		_dismissing = YES;
		[_captureSessionCoordinator stopRecording];
	} else {
		[self stopPipelineAndDismiss];
	}
}


#pragma mark - Private methods

- (void)configureInterface
{
	AVCaptureVideoPreviewLayer *previewLayer = [self.captureSessionCoordinator previewLayer];
	previewLayer.frame = self.view.bounds;
	[self.view.layer insertSublayer:previewLayer atIndex:0];
	
	[self.captureSessionCoordinator startRunning];
}

- (void)stopPipelineAndDismiss
{
	[self.captureSessionCoordinator stopRunning];
	[self dismissViewControllerAnimated:YES completion:nil];
	self.dismissing = NO;
}

- (void)checkPermissions
{
	WSPermissionManager *pm = [[WSPermissionManager alloc] init];
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
}

#pragma mark = WSCaptureSessionCoordinatorDelegate methods

- (void)coordinatorDidBeginRecording:(WSCaptureSessionCoordinator *)coordinator
{
	self.recordButton.enabled = YES;
}

- (void)coordinator:(WSCaptureSessionCoordinator *)coordinator didFinishRecordingToOutputFileURL:(NSURL *)outputFileURL error:(NSError *)error
{
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	
	_recordButton.title = @"Record";
	_recording = NO;
	
	//Do something useful with the video file available at the outputFileURL
	WSFileManager *fm = [[WSFileManager alloc] init];
	[fm writeFileToCameraRoll:outputFileURL];
	
	
	//Dismiss camera (when user taps cancel while camera is recording)
	if(_dismissing){
		[self stopPipelineAndDismiss];
	}
}
@end
