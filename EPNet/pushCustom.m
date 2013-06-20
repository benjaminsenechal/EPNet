//
//  pushCustom.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "pushCustom.h"

@implementation pushCustom
-(void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.duration = 0.4;
    transition.subtype = kCATransitionFromLeft;
    [sourceViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}
@end
