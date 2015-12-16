//
//  FNKGraphsDualAxisGraph.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/22/15.
//
//

import Foundation

class FNKGraphsDualAxisGraph: FNKGraphsViewController
{
    /* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
    var yLabelView: UIView? //TODO: should try to make thit let
    /* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
    var xLabelView: UIView? //TODO: should try to make thit let
    
    let xAxis: FNKXAxis
    let yAxis: FNKYAxis
    
    init(rect: CGRect, marginLeft: CGFloat, marginBottom: CGFloat) {
        
        self.xAxis = FNKXAxis(marginLeft: marginLeft, marginBottom: marginBottom, scaleFactor: 0.0, axisMin: 0.0, tickType: .Below, graphDimensions: rect)
        self.yAxis = FNKYAxis(marginLeft: marginLeft, marginBottom: marginBottom, scaleFactor: 0.0, axisMin: 0.0, tickType: .Outside, paddingPercentage: 0.0, graphDimensions: rect)
        
        super.init(rect: rect, marginLeft: marginLeft, marginBottom: marginBottom, graphWidth: rect.width - marginLeft, graphHeight: rect.height - marginBottom)
    }

    required init?(coder aDecoder: NSCoder) {
        //
    }
}