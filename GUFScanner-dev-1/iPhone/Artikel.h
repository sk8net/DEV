//
//  Artikel.h
//  BarcodeExample
//
//  Created by Tom Jowett on 2/1/13.
//  Copyright (c) 2013 Mobilogics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artikel : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *artikelNummer;
@property (strong, nonatomic) NSString *menge;
@property (strong, nonatomic) NSString *status;

- (id)initWithID:(NSString *)ID
   artikelNummer:(NSString *)artikelNummer
           menge:(NSString *)menge
          status:(NSString *)status;

@end
