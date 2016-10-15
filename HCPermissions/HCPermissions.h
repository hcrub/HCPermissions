//
//  HCPermissions.h
//  HCPermissions
//
//  Created by Neil Burchfield on 10/15/16.
//  Copyright © 2016 Neil Burchfield. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 HCPermissions
 
 @discussion
 Functional permissions access management.
 Requests complete upon success otherwise error.
 */

FOUNDATION_EXPORT NSInteger const kHCPermissionDeniedErrorCode;
FOUNDATION_EXPORT NSString *const kHCPermissionDeniedErrorDomain;

FOUNDATION_EXPORT NSInteger const kHCPermissionRestrictedErrorCode;
FOUNDATION_EXPORT NSString *const kHCPermissionRestrictedErrorDomain;

@class RACSignal;
@interface HCPermissions : NSObject

#pragma mark -
#pragma mark - Shared -

/**
 Shared Instance.
 
 @discussion All calls should be used through this.
 
 @return Single permission manager.
 */
+ (instancetype)sharedPermissions;

#pragma mark -
#pragma mark - Media -

typedef NS_ENUM(NSUInteger, HCMediaType) {
    HCMediaTypeCamera,
    HCMediaTypeMicrophone
};

#pragma mark - Microphone

/**
 Determines if the application has valid access to microphone. @KVO compliant.
 */
@property (readonly) BOOL hasMicrophoneAccess;

/**
 Requests access to the microphone.
 */
- (RACSignal *)requestMicrophoneAccess;

#pragma mark - Camera

/**
 Determines if the application has valid access to camera. @KVO compliant.
 */
@property (readonly) BOOL hasCameraAccess;

/**
 Requests access to the camera.
 */
- (RACSignal *)requestCameraAccess;

#pragma mark - Media

/**
 Determines whether the application has camera access for the type provided.
 
 @param mediaType The media type. See HCMediaType for available options.
 @return YES if the device has valid permissions, otherwise, NO.
 */
- (BOOL)hasMediaAccess:(HCMediaType)mediaType;

/**
 Requests for media access.
 
 @param mediaType The media type. See HCMediaType for available options.
 @return Signal that completes on success or error if failure.
 */
- (RACSignal *)requestMediaAccess:(HCMediaType)mediaType;

@end

NS_ASSUME_NONNULL_END
