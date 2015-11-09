//
//  WSPermissionManager.h
//  WSFCam
//
//  Created by Alma IT on 9/11/15.
//  Copyright © 2015 WildStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSPermissionManager : NSObject

- (void)checkMicrophonePermissionsWithBlock:(void(^)(BOOL granted))block;
- (void)checkCameraAuthorizationStatusWithBlock:(void(^)(BOOL granted))block;

@end
