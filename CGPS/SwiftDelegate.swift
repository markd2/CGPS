//
//  SwiftDelegate.swift
//  CGPS
//
//  Created by Mark Dalrymple on 9/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa
import CoreGraphics
import Darwin

let initialText = "" +
"/ComicSansMS findfont\n" +
"40 scalefont\n" +
"setfont\n" +
"\n" +
"20 50 translate\n" +
"30 rotate\n" +
"2.5 1 scale\n" +
"\n" +
"newpath\n" +
"0 0 moveto\n" +
"(Swift Bork) true charpath\n" +
"0.9 setgray\n" +
"fill\n" +
"\n" +
"newpath\n" +
"0 0 moveto\n" +
"(Swift Bork) true charpath\n" +
"0.3 setgray\n" +
"1 setlinewidth\n" +
"stroke\n"


class SwiftDelegate: NSObject {

    @IBOutlet var codeText : NSTextView!
    @IBOutlet var pdfView : XXPDFView!
    
    override func awakeFromNib() {
        self.codeText.string = initialText
    }
    
    @IBAction func draw(AnyObject) {
    
        let callbacks = UnsafeMutablePointer<CGPSConverterCallbacks>.alloc(1)
        bzero(callbacks, UInt(sizeof(CGPSConverterCallbacks.self)))
        
        let converter = CGPSConverterCreate (nil, callbacks, nil)
        let code = self.codeText.string

        let codeCString = (code as NSString).UTF8String
        let provider = CGDataProviderCreateWithData (nil,
            codeCString, strlen(codeCString), nil)
        
        let data = NSMutableData()
        let consumer = CGDataConsumerCreateWithCFData (data)
        let converted = CGPSConverterConvert (converter, provider, consumer, nil)
        
        if converted {
            println("yay")
        } else {
            println("boo")
        }
        
        let pdfDataProvider = CGDataProviderCreateWithCFData(data)
        let pdf = CGPDFDocumentCreateWithProvider(pdfDataProvider)
        self.pdfView.pdfDocument = pdf
        
        callbacks.dealloc(1)
    }
    
}
