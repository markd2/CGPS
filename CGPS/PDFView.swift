//
//  PDFView.swift
//  CGPS
//
//  Created by Mark Dalrymple on 9/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

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
        
        guard let pdf = pdfDocument,  
            let page1 = pdf.page(at: 1),  
            let context = NSGraphicsContext.current?.cgContext else { return }
        
        context.drawPDFPage(page1)
        
        NSColor.black.set()
        bounds.frame()
    }
}

