//
//  FNKBarSectionData.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

class FNKBarSectionData
{
    let data: AnyObject
    let bucket: Int
    
    init(data: AnyObject, bucket: Int)
    {
        self.data = data
        self.bucket = bucket
    }
}