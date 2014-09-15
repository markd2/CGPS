//
//  PDFView.swift
//  CGPS
//
//  Created by Mark Dalrymple on 9/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa
import CoreGraphics

extension NSGraphicsContext {
    var CoreGraphicsContext: CGContextRef {
        return unsafeBitCast(self.graphicsPort, CGContextRef.self)
    }
}


class PDFView: NSView {

    var pdfDocument : CGPDFDocumentRef? {
        willSet {
            needsDisplay = true
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        NSColor.whiteColor().set()
        NSRectFill(bounds)
        
        if let pdf = pdfDocument {
            let page1 = CGPDFDocumentGetPage(self.pdfDocument, 1)
            
            // This took an _insane_ amount of time to get working.
            // the bit cast docs say:
            //     "A brutal bit-cast of something to anything of the same size"
            let contextPointer = NSGraphicsContext.currentContext().graphicsPort
            let context = unsafeBitCast(contextPointer, CGContextRef.self)
            
            CGContextDrawPDFPage (context, page1)
        }
        
        NSColor.blackColor().set()
        NSFrameRect(bounds)
    }
}

