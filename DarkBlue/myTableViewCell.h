//
//  myTableViewCell.h
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topName;
@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *service;
@property (weak, nonatomic) IBOutlet UILabel *RSSI;

@end
