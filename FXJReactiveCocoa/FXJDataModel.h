//
//  FXJDataModel.h
//  FXJReactiveCocoa
//
//  Created by myApplePro01 on 16/4/22.
//  Copyright © 2016年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXJDataModel : NSObject
@property (nonatomic, copy) NSString                *name;
@property (nonatomic, copy) NSString                *age;
@property (nonatomic, copy) NSString                *number;

+ (FXJDataModel *)flagWithDict:(id)dict;
@end
