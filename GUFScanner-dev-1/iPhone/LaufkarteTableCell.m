//
//  LaufkarteTableCell.m
//  BarcodeExample
//
//  Created by Tom Jowett on 5/1/13.
//  Copyright (c) 2013 Mobilogics. All rights reserved.
//

#import "LaufkarteTableCell.h"

@implementation LaufkarteTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_namePrependedToBezeichnungLabel release];
    [_bemerkungLabel release];
    [_toggleStatusButton release];
    [super dealloc];
}
@end
