//
//  PresentTwoController.h
//  KVRouterDemo
//
//  Created by kevin on 2018/4/2.
//  Copyright © 2018年 kv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentTwoControllerDelegate <NSObject>

- (void)dismissbackWithParameter:(NSDictionary*)parameter;

@end

@interface PresentTwoController : UIViewController

@property (nonatomic, weak) id <PresentTwoControllerDelegate> delegate;

@end
