//
//  FNKHistogramBucketData.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

class FNKHistogramBucketData
{
    let data: Float
    var minDate: NSDate?
    var maxDate: NSDate?
    
    
    init(data: Float)
    {
        self.data = data
    }
    
    func addDate(date: NSDate)
    {
        if(self.minDate == nil || date.compare(self.minDate!) == .OrderedAscending)
        {
            self.minDate = date;
        }
        
        if(self.maxDate == nil || date.compare(self.maxDate!) == .OrderedAscending)
        {
            self.maxDate = date;
        }
    }
}