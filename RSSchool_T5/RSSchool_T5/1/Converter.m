#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    
    NSMutableString *resultNumber = [NSMutableString new];
    NSMutableString *resultKeyCountry = [NSMutableString new];
    
    NSDictionary *phoneFormats = @{
        @"RU": @"(xxx) xxx-xx-xx",
        @"KZ": @"(xxx) xxx-xx-xx",
        @"MD": @"(xx) xxx-xxx",
        @"AM": @"(xx) xxx-xxx",
        @"BY": @"(xx) xxx-xx-xx",
        @"UA": @"(xx) xxx-xx-xx",
        @"TJ": @"(xx) xxx-xx-xx",
        @"TM": @"(xx) xxx-xxx",
        @"AZ": @"(xx) xxx-xx-xx",
        @"KG": @"(xx) xxx-xx-xx",
        @"UZ": @"(xx) xxx-xx-xx"
    };
    
    NSDictionary *countryCodes = @{
        @"7"  : @"RU",
        @"7"  : @"KZ",
        @"373": @"MD",
        @"374": @"AM",
        @"375": @"BY",
        @"380": @"UA",
        @"992": @"TJ",
        @"993": @"TM",
        @"994": @"AZ",
        @"996": @"KG",
        @"998": @"UZ"
    };
    
    if (string.length > 12) {
        int firstNumber = 0;
        for (int i=0; i < string.length; i++) {
            if (![[string substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"+"]) {
                firstNumber = i;
                break;
            }
        };
        string = [string substringWithRange:NSMakeRange(firstNumber, 12)];
    }
    
    NSMutableString *code = [NSMutableString new];
    
    if (![[string substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"+"]) {
        [resultNumber appendString:@"+"];
    };
    
    for (int i = 0; i < string.length; i++) {
        
        NSString *ch = [string substringWithRange:NSMakeRange(i, 1)];
        if ([ch isEqualToString:@"+"]) {
            continue;
        } else {
            [code appendString:ch];
        }
        
        NSString *value = [countryCodes objectForKey:code];
        if (value != nil) {
            
            if (string.length == 1) {
                return @{KeyPhoneNumber: [@"+" stringByAppendingString:code], KeyCountry: value};
            }
            
            if ([code isEqualToString:@"7"]) {
                //check KZ
                if ([[string substringWithRange:NSMakeRange(i+1, 1)] isEqualToString:@"7"]) {
                    [resultKeyCountry appendString:@"KZ"];
                } else {
                    [resultKeyCountry appendString:@"RU"];
                }
            } else {
                [resultKeyCountry appendString:value];
            }
            [resultNumber appendString:code];
            if (string.length > code.length) {
                [resultNumber appendString:@" "];
                [resultNumber appendString:[self getFormatNumber:[string substringWithRange:NSMakeRange(code.length, string.length-code.length)] with:[phoneFormats objectForKey:resultKeyCountry]]];
            }
            return @{KeyPhoneNumber: resultNumber, KeyCountry: resultKeyCountry};
        }
    }
    
    return @{KeyPhoneNumber: [@"+" stringByAppendingString:code], KeyCountry: @""};
}

-(NSString *) getFormatNumber: (NSString *) number with: (NSString *) formatString {
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:formatString];
    
    for (int i=0; i < number.length; i++) {
        NSString *ch = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [result rangeOfString:@"x"];
        if (range.location != NSNotFound) {
            [result replaceCharactersInRange:range withString:ch];
        }
    }
    
    while ([result rangeOfString:@"x"].location != NSNotFound) {
         [result replaceCharactersInRange:[result rangeOfString:@"x"] withString:@""];
    }
    
    while ([[result substringFromIndex:result.length-1] isEqualToString:@"-"]) {
        [result deleteCharactersInRange:NSMakeRange(result.length-1, 1)];
    }
    while ([[result substringFromIndex:result.length-1] isEqualToString:@" "]) {
        [result deleteCharactersInRange:NSMakeRange(result.length-1, 1)];
    }
    while ([[result substringFromIndex:result.length-1] isEqualToString:@")"]) {
           [result deleteCharactersInRange:NSMakeRange(result.length-1, 1)];
    }
    
    return result;
}


@end
