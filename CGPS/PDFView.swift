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
    var CoreGraphicsContext: CGContext {
        return unsafeBitCast(self.graphicsPort, to: CGContext.self)
    }
}


class PDFView: NSView {

    var pdfDocument : CGPDFDocument? {
        willSet {
            needsDisplay = true
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.white.set()
        bounds.fill()
        
        if let pdf = pdfDocument {
            let page1 = pdf.page(at: 1)
            
            // This took an _insane_ amount of time to get working.
            // the bit cast docs say:
            //     "A brutal bit-cast of something to anything of the same size"
            let contextPointer = NSGraphicsContext.current?.graphicsPort
            let context = unsafeBitCast(contextPointer, to: CGContext.self)
            context.drawPDFPage(page1!)
        }
        
        NSColor.black.set()
        bounds.frame()
    }
}

