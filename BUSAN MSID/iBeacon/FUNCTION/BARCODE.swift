//
//  BARCODE.swift
//  APT
//
//  Created by i-Mac on 21/09/2020.
//  Copyright © 2019 장제현. All rights reserved.
//

import UIKit
import Foundation

enum BARCODE_TYPE: String {
    
    case QR_CODE = "CIQRCodeGenerator"
    case PDF_417 = "CIPDF417BarcodeGenerator"
    case CODE_128 = "CICode128BarcodeGenerator"
    case AZTEC = "CIAztecCodeGenerator"
}

struct BARCODE {
    
    // MARK: Public Methods
    func BARCODE(CODE: String, TYPE: BARCODE_TYPE, SIZE: CGSize) -> UIImage? {
        
        if let FILTER = FILTER(CODE: CODE, TYPE: TYPE) {
            return IMAGE(FILTER: FILTER, SIZE: SIZE)
        }
        return nil
    }
    
    // MARK: Private Methods
    fileprivate func IMAGE(FILTER : CIFilter, SIZE: CGSize) -> UIImage? {
        
        if let IMAGE = FILTER.outputImage {
            
            let SCALE_X = SIZE.width / IMAGE.extent.size.width
            let SCALE_Y = SIZE.height / IMAGE.extent.size.height
            let TRANSFORMED_IMAGE = IMAGE.transformed(by: CGAffineTransform(scaleX: SCALE_X, y: SCALE_Y))
            
            return UIImage(ciImage: TRANSFORMED_IMAGE)
        }
        return nil
    }
    
    fileprivate func FILTER(CODE: String, TYPE: BARCODE_TYPE) -> CIFilter? {
        
        if let FILTER = CIFilter(name: TYPE.rawValue) {
            
            guard let DATA = CODE.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return nil }
            FILTER.setValue(DATA, forKey: "inputMessage")
            
            return FILTER
        }
        return nil
    }
}
