//
//  SwiftDelegate.swift
//  CGPS
//
//  Created by Mark Dalrymple on 9/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

let initialText = """
    /ComicSansMS findfont
    40 scalefont
    setfont

    20 50 translate
    30 rotate
    2.5 1 scale

    newpath
    0 0 moveto
    (SwiftBork) true charpath
    0.9 setgray
    fill

    newpath
    0 0 moveto
    (SwiftBork) true charpath
    0.3 setgray
    1 setlinewidth
    stroke
    """


class SwiftDelegate: NSObject {

    @IBOutlet var codeText : NSTextView!
    @IBOutlet var pdfView : PDFView!
    
    override func awakeFromNib() {
        self.codeText.string = initialText
    }
    
    @IBAction func draw(_ sender: AnyObject) {
        var callbacks = CGPSConverterCallbacks()
        
        guard let converter = CGPSConverter(info: nil, callbacks: &callbacks, options: nil) else { return }
        
        self.codeText.string.withCString { codeCString in
            guard let dataProvider: CGDataProvider = CGDataProvider(dataInfo: nil, 
                                                                    data: codeCString, 
                                                                    size: strlen(codeCString), 
                                                                    releaseData: { (_,_,_) in }) else { return }
            let data = NSMutableData()
            guard let consumer = CGDataConsumer(data: data) else { return }

            let converted = converter.convert (dataProvider, consumer: consumer, options: nil)
            if !converted {
                print("boo")
            }
            
            guard let pdfDataProvider = CGDataProvider(data: data) else { return }
            let pdf = CGPDFDocument(pdfDataProvider)
            self.pdfView.pdfDocument = pdf
        }
    }
}



