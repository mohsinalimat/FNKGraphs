//
//  FNKLineGraphRange.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

class FNKLineGraphRange
{
    let xScaleFactor: CGFloat
    let yScaleFactor: CGFloat
    let xRange: CGFloat
    let yRange: CGFloat
    let minX: CGFloat
    let minY: CGFloat
    
    init(xScaleFactor: CGFloat, yScaleFactor: CGFloat, xRange: CGFloat, yRange: CGFloat, minX: CGFloat, minY: CGFloat)
    {
        self.xScaleFactor = xScaleFactor
        self.yScaleFactor = yScaleFactor
        self.xRange = xRange
        self.yRange = yRange
        self.minX = minX
        self.minY = minY
    }
    
    convenience init?(points: Array<NSValue>, overridingXMin:CGFloat?, overridingXMax:CGFloat?, overridingYMin:CGFloat?, overridingYMax:CGFloat?, yPaddingPercentage:CGFloat, graphWidth:CGFloat, graphHeight:CGFloat)
    {
        var maxX = CGFloat.NaN
        var minX = CGFloat.infinity
        var maxY = CGFloat.NaN
        var minY = CGFloat.infinity
        
        for val in points
        {
            let point = val.CGPointValue()
            
            if(point.x > maxX)
            {
                maxX = point.x
            }
            
            if(point.x < minX)
            {
                minX = point.x
            }
            
            if(point.y > maxY)
            {
                maxY = point.y
            }
            
            if(point.y < minY)
            {
                minY = point.y
            }
        }
        
        if(overridingYMin != nil && overridingYMin < minY)
        {
            minY = overridingYMin!
        }
        
        if(overridingYMax != nil && overridingYMax > maxY)
        {
            maxY = overridingYMax!
        }
        
        if(overridingXMin != nil && overridingXMin < minX)
        {
            minX = overridingXMin!
        }
        
        if(overridingXMax != nil && overridingXMax > maxX)
        {
            maxX = overridingXMax!
        }
        
        if(maxX.isNaN || minX.isInfinite || maxY.isNaN || minY.isInfinite)
        {
            NSLog("FNKGraphsLineGraphViewController: The max or min on one of your axii is infinite!", [])
            return nil
        }
        
        let yPadding = (maxY - minY) * yPaddingPercentage
        
        minY = minY - yPadding
        maxY = maxY + yPadding
        
        //Okay so now we have the min's and max's
        var xr = maxX - minX
        var yr = maxY - minY
        
        if(yr == 0)
        {
            //Just make a range of 10%
            let percentRange = maxY * 0.1
            maxY = maxY + percentRange
            minY = minY - percentRange
            yr = maxY - minY
        }
        
        if(xr == 0)
        {
            //Just make a range of 10%
            let percentRange = maxX * 0.1
            maxX = maxX + percentRange
            minX = minX - percentRange
            xr = maxX - minX
        }

        self.init(xScaleFactor: graphWidth / xr, yScaleFactor: graphHeight / yr, xRange: xr, yRange: yr, minX: minX, minY: minY)
    }
}