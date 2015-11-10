//
//  WSFileManager.h
//  WSFCam
//
//  Created by Alma IT on 9/11/15.
//  Copyright © 2015 WildStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSFileManager : NSObject

- (NSURL *) tempFileURL;
- (void) writeFileToCameraRoll:(NSURL *)fileURL;

@end
