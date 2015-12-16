//
//  FNKChartsViewDelegate.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

@objc
protocol FNKChartsViewDelegate
{
    optional func touchedGraph(chart: FNKGraphsViewController, val:Float, point:CGPoint, userGenerated:Bool)
    optional func graphTouchesEnded(chart: FNKGraphsViewController)
//    optional func touchedBar(chart: FNKGraphsViewController, data: FNKChartOverlayData)
    
    //Returns -1 as the index if no slices are selected
    optional func pieSliceSelected(chart: FNKGraphsViewController, sliceIndex:Int)
}