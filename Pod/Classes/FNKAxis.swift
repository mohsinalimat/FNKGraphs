//
//  FNKAxis.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

class FNKAxis: NSObject
{
    //Graph Sizes
    let marginLeft: CGFloat
    let marginBottom: CGFloat
    let graphDimensions : CGRect
    var scaleFactor: CGFloat = 1
    var axisMin : CGFloat = 0
    
    var overridingMax: CGFloat?
    var overridingMin: CGFloat?
    var animationDuration: NSTimeInterval = 1.0
    
    var ticks: Int = 5
    let fillColor: UIColor
    let strokeColor: UIColor
    
    let tickFillColor: UIColor
    let tickStrokeColor: UIColor
    
    var tickFont: UIFont
    var tickLabelColor: UIColor
    
    
    init(marginLeft: CGFloat, marginBottom: CGFloat, scaleFactor: CGFloat, axisMin: CGFloat, graphDimensions: CGRect)
    {
        self.marginLeft = marginLeft
        self.marginBottom = marginBottom
        self.tickFont = UIFont(name: "Avenir", size: 9)!
        self.tickLabelColor = UIColor.blackColor()
        self.animationDuration = 0.7
        self.scaleFactor = scaleFactor
        self.axisMin = axisMin
        self.fillColor = UIColor.blackColor()
        self.strokeColor = UIColor.blackColor()
        self.tickFillColor = UIColor.blackColor()
        self.tickStrokeColor = UIColor.blackColor()
        self.graphDimensions = graphDimensions
    }

    func addTicksToView(view: UIView, tickFormat: (CGFloat) -> (String)) -> UIView?
    {
        return nil
    }
    
    func drawAxis(view: UIView)
    {
    }
}