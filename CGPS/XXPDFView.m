//
//  XXPDFView.m
//  CGPS
//
//  Created by Mark Dalrymple on 9/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "XXPDFView.h"

@implementation XXPDFView
@synthesize pdfDocument = _pdfDocument;

- (CGPDFPageRef) firstPage {

    CGPDFPageRef page1 =  CGPDFDocumentGetPage (self.pdfDocument, 1);
    assert(page1);

    return page1;
} // firstPage


- (void) setPdfDocument: (CGPDFDocumentRef) pdfDocument {
    CGPDFDocumentRetain(pdfDocument);
    CGPDFDocumentRelease(_pdfDocument);
    
    _pdfDocument = pdfDocument;
    
    [self setNeedsDisplay: YES];
} // setPdfDocument


- (CGPDFDocumentRef) pdfDocument {
    return _pdfDocument;
} // pdfDocument


- (void) drawRect: (CGRect) dirtyRect {
    [super drawRect: dirtyRect];
    
    [NSColor.whiteColor set];
    NSRectFill (self.bounds);
    
    if (self.pdfDocument) {
        CGContextRef context = [NSGraphicsContext.currentContext graphicsPort];
        CGContextDrawPDFPage (context, self.firstPage);
    }
    
    [NSColor.blackColor set];
    NSFrameRect (self.bounds);
    
    
} // drawRect

@end
