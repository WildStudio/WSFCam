//
//  WSCaptureSessionMovieFileOutputCoordinator.m
//  WSFCam
//
//  Created by Alma IT on 10/11/15.
//  Copyright © 2015 WildStudio. All rights reserved.
//

#import "WSCaptureSessionMovieFileOutputCoordinator.h"
#import "WSFileManager.h"

@interface WSCaptureSessionMovieFileOutputCoordinator () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;

@end

@implementation WSCaptureSessionMovieFileOutputCoordinator

- (instancetype)init
{
	self = [super init];
	if(self){
		[self addMovieFileOutputToCaptureSession:self.captureSession];
	}
	return self;
}

#pragma mark - Private methods

- (BOOL)addMovieFileOutputToCaptureSession:(AVCaptureSession *)captureSession
{
	self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
	return  [self addOutput:_movieFileOutput toCaptureSession:captureSession];
}

#pragma mark - Recording

- (void)startRecording
{
	WSFileManager *fm = [WSFileManager new];
	NSURL *tempURL = [fm tempFileURL];
	[_movieFileOutput startRecordingToOutputFileURL:tempURL recordingDelegate:self];
}

- (void)stopRecording
{
	[_movieFileOutput stopRecording];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
			fromConnections:(NSArray *)connections
{
	//Recording started
	[self.delegate coordinatorDidBeginRecording:self];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
	//Recording finished - do something with the file at outputFileURL
	[self.delegate coordinator:self didFinishRecordingToOutputFileURL:outputFileURL error:error];
	
}


@end
