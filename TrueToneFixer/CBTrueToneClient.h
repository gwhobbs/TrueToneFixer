//
//  CBTrueToneClient.h
//  TrueToneFixer
//
//  Created by Grant Hobbs on 3/19/22.
//

#import <Foundation/Foundation.h>

@interface CBTrueToneClient : NSObject
- (BOOL)available;
- (BOOL)supported;
- (BOOL)enabled;
- (BOOL)setEnabled:(BOOL)arg1;
@end
