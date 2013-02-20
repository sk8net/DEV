//
//  BestellInformationTableViewCell.m
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 2/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import "BestellInformationTableViewCell.h"

@implementation BestellInformationTableViewCell

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
    [_posLabel release];
    [_artNrLabel release];
    [_mengeLabel release];
    [_statusLabel release];
    [super dealloc];
}
@end
