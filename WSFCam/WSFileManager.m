//
//  WSFileManager.m
//  WSFCam
//
//  Created by Alma IT on 9/11/15.
//  Copyright © 2015 WildStudio. All rights reserved.
//

#import <Photos/PHAssetChangeRequest.h>
#import "WSFileManager.h"


@implementation WSFileManager

- (NSURL *)tempFileURL
{
	NSString *path = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSInteger i = 0;
	while(path == nil || [fm fileExistsAtPath:path]){
		path = [NSString stringWithFormat:@"%@output%ld.mov", NSTemporaryDirectory(), (long)i];
		i++;
	}
	return [NSURL fileURLWithPath:path];
}

- (void) writeFileToCameraRoll:(NSURL *)fileURL
{
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
		// Create a change request from the asset to be modified.
		PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
		PHObjectPlaceholder *assetPlaceholder = assetRequest.placeholderForCreatedAsset;;
	
	} completionHandler:^(BOOL success, NSError *error) {
		NSLog(@"Finished updating asset. %@", (success ? @"Success." : error));
	}];}

@end
