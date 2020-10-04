//
//  StringUtils.swift
//  NoiseExample
//
//  Created by Tomas Baculák on 04/10/2020.
//

import Foundation

func hfsTypeCode(_ fileTypeString: String) -> OSType {
    var result: OSType = 0
    var i: UInt32 = 0
    
    for uc in fileTypeString.unicodeScalars {
        result |= OSType(uc) << ((3 - i) * 8)
        i += 1
    }
    return result;
}
