//
//  Artikel.m
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 2/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import "Artikel.h"

@implementation Artikel

- (id)initWithID:(NSString *)ID
   artikelNummer:(NSString *)artikelNummer
           menge:(NSString *)menge
          status:(NSString *)status {
    if (self = [super init]) {
        if (ID != nil) {
            _ID = [NSString stringWithString:ID];
        } else {
            _ID = nil;
        }
        
        if (artikelNummer != nil) {
            _artikelNummer = [NSString stringWithString:artikelNummer];
        } else {
            _artikelNummer = nil;
        }
        
        if (menge != nil) {
            _menge = [NSString stringWithString:menge];
        } else {
            _menge = nil;
        }
        
        if (status != nil) {
            _status = [NSString stringWithString:status];
        } else {
            _status = nil;
        }
    }
    return self;
}

@end
