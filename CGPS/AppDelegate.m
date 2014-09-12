//
//  AppDelegate.m
//  CGPS
//
//  Created by Mark Dalrymple on 9/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreGraphics/CoreGraphics.h>
#import "XXPDFView.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet XXPDFView *pdfView;
@property (assign) IBOutlet NSTextView *codeText;

@end

static NSString *ps =
@"/ComicSansMS findfont\n"
"40 scalefont\n"
"setfont\n"
"\n"
"30 50 translate\n"
"30 rotate\n"
"2.5 1 scale\n"
"\n"
"newpath\n"
"0 0 moveto\n"
"(Bork Bork) true charpath\n"
"0.9 setgray\n"
"fill\n"
"\n"
"newpath\n"
"0 0 moveto\n"
"(Bork Bork) true charpath\n"
"0.3 setgray\n"
"1 setlinewidth\n"
"stroke\n";


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.codeText.string = ps;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {

}

- (IBAction) draw: (NSButton *) sender {
    struct CGPSConverterCallbacks callbacks = { 0 };
    
    CGPSConverterRef converter = CGPSConverterCreate (NULL, &callbacks,NULL);
    
    NSString *code = self.codeText.string;
    
    CGDataProviderRef provider = CGDataProviderCreateWithData (NULL,
                                                               code.UTF8String,
                                                               strlen(code.UTF8String),
                                                               NULL);
    
    NSMutableData *data = NSMutableData.data;
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData ((__bridge CFMutableDataRef)data);
    
    bool converted = CGPSConverterConvert (converter, provider, consumer, NULL);
    
    if (converted) {
        NSLog (@"YAY");
    } else {
        NSLog (@"BOO");
    }
    
    CGDataProviderRelease (provider);
    CGDataConsumerRelease (consumer);
    
    CGDataProviderRef pdfDataProvider = CGDataProviderCreateWithCFData ((__bridge CFMutableDataRef)data);
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(pdfDataProvider);
    
    CGDataProviderRelease(pdfDataProvider);

    self.pdfView.pdfDocument = pdf;
    
    CGPDFDocumentRelease (pdf);
    
} // draw

@end
