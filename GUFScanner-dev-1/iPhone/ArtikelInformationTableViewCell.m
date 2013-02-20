//
//  ArtikelInformationTableViewCell.m
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 5/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import "ArtikelInformationTableViewCell.h"

@implementation ArtikelInformationTableViewCell

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
    [_dokumentLabel release];
    [super dealloc];
}
@end
