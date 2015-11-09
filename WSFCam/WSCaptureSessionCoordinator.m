//
//  WSCaptureSessionCoordinator.m
//  WSFCam
//
//  Created by Christian Aranda on 9/11/15.
//  Copyright © 2015 WildStudio. All rights reserved.
//

#import "WSCaptureSessionCoordinator.h"

@interface WSCaptureSessionCoordinator ()

@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end
@implementation WSCaptureSessionCoordinator

- (instancetype)init
{
    self = [super init];
    if(self){
        _sessionQueue = dispatch_queue_create( "com.example.capturepipeline.session", DISPATCH_QUEUE_SERIAL );
        _captureSession = [self setupCaptureSession];
    }
    return self;
}

- (void)setDelegate:(id<WSCaptureSessionCoordinatorDelegate>)delegate callbackQueue:(dispatch_queue_t)delegateCallbackQueue
{
    if(delegate && ( delegateCallbackQueue == NULL)){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Caller must provide a delegateCallbackQueue" userInfo:nil];
    }
    @synchronized(self)
    {
        _delegate = delegate;
        if (delegateCallbackQueue != _delegateCallbackQueue){
            _delegateCallbackQueue = delegateCallbackQueue;
        }
    }

}

- (void)startRunning
{
	dispatch_sync( _sessionQueue, ^{
		[_captureSession startRunning];
	} );
}

- (void)stopRunning
{
	dispatch_sync( _sessionQueue, ^{
		// the captureSessionDidStopRunning method will stop recording if necessary as well, but we do it here so that the last video and audio samples are better aligned
		[self stopRecording]; // does nothing if we aren't currently recording
		[_captureSession stopRunning];
	} );
}

- (void)startRecording
{
	
}

- (void)stopRecording
{
	
}


#pragma mark - Capture Session Setup

- (AVCaptureSession *)setupCaptureSession
{
	AVCaptureSession *captureSession = [AVCaptureSession new];
	
	if(![self addDefaultCameraInputToCaptureSession:captureSession]){
		NSLog(@"failed to add camera input to capture session");
	}
	if(![self addDefaultMicInputToCaptureSession:captureSession]){
		NSLog(@"failed to add mic input to capture session");
	}
	
	return captureSession;
}

- (BOOL)addDefaultCameraInputToCaptureSession:(AVCaptureSession *)captureSession
{
	NSError *error;
	AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
	
	if(error){
		NSLog(@"error configuring camera input: %@", [error localizedDescription]);
		return NO;
	} else {
		BOOL success = [self addInput:cameraDeviceInput toCaptureSession:captureSession];
		_cameraDevice = cameraDeviceInput.device;
		return success;
	}
}

- (BOOL)addDefaultMicInputToCaptureSession:(AVCaptureSession *)captureSession
{
	NSError *error;
	AVCaptureDeviceInput *micDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
	if(error){
		NSLog(@"error configuring mic input: %@", [error localizedDescription]);
		return NO;
	} else {
		BOOL success = [self addInput:micDeviceInput toCaptureSession:captureSession];
		return success;
	}
}

- (BOOL)addInput:(AVCaptureDeviceInput *)input toCaptureSession:(AVCaptureSession *)captureSession
{
	if([captureSession canAddInput:input]){
		[captureSession addInput:input];
		return YES;
	} else {
		NSLog(@"can't add input: %@", [input description]);
	}
	return NO;
}

-(BOOL)addOutput:(AVCaptureOutput *)output toCaptureSession:(AVCaptureSession *)captureSession
{
	if([captureSession canAddOutput:output]){
		[captureSession addOutput:output];
		return YES;
	}else{
		NSLog(@"can't add output: %@", [output description]);
	}
	return NO;
}


@end
