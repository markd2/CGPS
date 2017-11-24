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
    @IBOutlet var pdfView : PDFView!
    
    override func awakeFromNib() {
        self.codeText.string = initialText
    }
    
    @IBAction func draw(_ sender: AnyObject) {
    
        let callbacks = UnsafeMutablePointer<CGPSConverterCallbacks>.allocate(capacity: 1)
        bzero(callbacks, MemoryLayout<CGPSConverterCallbacks>.size)
        
        let converter = CGPSConverter (info: nil, callbacks: callbacks, options: nil)
        let code = self.codeText.string

        let codeCString = (code as NSString).utf8String
        
        let releaseMe: CGDataProviderReleaseDataCallback = { (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> () in
            // https://developer.apple.com/reference/coregraphics/cgdataproviderreleasedatacallback
            // N.B. 'CGDataProviderRelease' is unavailable: Core Foundation objects are automatically memory managed
            return
        }
    
        let dataProvider: CGDataProvider = CGDataProvider(dataInfo: nil, 
            data: codeCString!, size: strlen(codeCString), releaseData: releaseMe)!
        
        
        let data = NSMutableData()
        let consumer = CGDataConsumer (data: data)
        let converted = converter!.convert (dataProvider, consumer: consumer!, options: nil)
        
        if !converted {
            print("boo")
        }
        
        let pdfDataProvider = CGDataProvider(data: data)
        let pdf = CGPDFDocument(pdfDataProvider!)
        self.pdfView.pdfDocument = pdf
        
        callbacks.deallocate(capacity: 1)
    }
    
}
