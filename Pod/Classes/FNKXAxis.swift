//
//  FNKXAxis.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation
import UIKit

class FNKXAxis: FNKAxis
{
    let tickType: FNKXAxisTickType
    
    static let FNKTallTickHeight : CGFloat = 10
    
    init(marginLeft: CGFloat, marginBottom: CGFloat, scaleFactor: CGFloat, axisMin: CGFloat, tickType: FNKXAxisTickType, graphDimensions: CGRect)
    {
        self.tickType = tickType
        super.init(marginLeft: marginLeft, marginBottom: marginBottom, scaleFactor: scaleFactor, axisMin: axisMin, graphDimensions: graphDimensions)
    }
    
    override func drawAxis(view: UIView)
    {
        let bezPath = UIBezierPath()
        bezPath.moveToPoint(CGPoint(x: self.marginLeft, y: self.graphDimensions.height))
        bezPath.addLineToPoint(CGPoint(x: self.graphDimensions.width + self.marginLeft, y: self.graphDimensions.height))
        bezPath.closePath()
        
        let layer = CAShapeLayer()
        layer.path = bezPath.CGPath
        layer.fillColor = self.fillColor.CGColor
        layer.strokeColor = self.strokeColor.CGColor
        
        view.layer.addSublayer(layer)
    }

    override func addTicksToView(view: UIView, tickFormat: (CGFloat) -> (String)) -> UIView?
    {
        let tickInterval = self.graphDimensions.width / CGFloat(self.ticks)
        
        let labelYLoc = self.tickType == .TallTickBelow ? view.frame.size.height + FNKXAxis.FNKTallTickHeight/2 : view.frame.size.height
        
        let labelView = UIView(frame: CGRectMake(0, labelYLoc, view.frame.size.width, 20))
        
        let textHeight: CGFloat = 0
        
        for index in 0...self.ticks+1
        {
            let bezPath = UIBezierPath()
            
            let xVal = self.marginLeft + (CGFloat(index) * tickInterval);
            
            if(self.tickType == .TallTickBelow)
            {
                let yVal = self.graphDimensions.height - FNKXAxis.FNKTallTickHeight / 2;
                
                bezPath.moveToPoint(CGPointMake(xVal, yVal))
                bezPath.addLineToPoint(CGPointMake(xVal, yVal + FNKXAxis.FNKTallTickHeight))
            }
            else
            {
                bezPath.moveToPoint(CGPointMake(xVal, self.graphDimensions.height))
                bezPath.addLineToPoint(CGPointMake(xVal, self.graphDimensions.height + 3))
            }
        
            let layer = CAShapeLayer()
            layer.path = bezPath.CGPath
            layer.fillColor = self.tickFillColor.CGColor
            layer.strokeColor = self.tickStrokeColor.CGColor
            
            view.layer.addSublayer(layer)
            
            //Okay those are the ticks. Now we need the labels
            
            let tickLabel = UILabel()
            if(self.scaleFactor == 0)
            {
                tickLabel.text = tickFormat(xVal - self.marginLeft)
            }
            else
            {
                tickLabel.text = tickFormat(((xVal - self.marginLeft) / self.scaleFactor) + self.axisMin)
            }
            tickLabel.sizeToFit()
            
            let textWidth = tickLabel.frame.size.width
            let textHeight = tickLabel.frame.size.height
        
            if(index == 0 && xVal == 0)
            {
                tickLabel.frame = CGRectMake(xVal - 2, 0, textWidth, textHeight)
                tickLabel.textAlignment = .Left
            }
            else if(index == self.ticks && xVal == labelView.frame.size.width)
            {
                tickLabel.frame = CGRectMake(xVal - textWidth + 2, 0, textWidth, textHeight)
                tickLabel.textAlignment = .Right
            }
            else
            {
                tickLabel.frame = CGRectMake( xVal - textWidth/2, 0, textWidth, textHeight)
                tickLabel.textAlignment = .Center
            }
            
            tickLabel.font = self.tickFont
            tickLabel.textColor = self.tickLabelColor
            labelView.addSubview(tickLabel)
        }
        
        labelView.frame = CGRectMake(labelView.frame.origin.x, labelView.frame.origin.y, labelView.frame.size.width, textHeight)
        
        labelView.alpha = 0.0
        
        view.addSubview(labelView)

        UIView.animateWithDuration(1) { () -> Void in
            labelView.alpha = 1.0
        }
        
        return labelView;
    }
    
    //TODO: Break this out into it's on seperate class. So FNKXAxis is the parent class of Bar graph x axis
    func addTicksToView(view: UIView, bars:Array<FNKBar>, tickFormat: ((Int) -> String)?) -> UIView?
    {
        let labelView = UIView(frame:CGRectMake(0, view.frame.size.height, view.frame.size.width, 20))
        
        //Let's show 5 ticks at most.
        let tickInterval = bars.count/5 != 0 ? bars.count/5 : 1
        
        for index in 0...bars.count
        {
            if(index%tickInterval != 0)
            {
                continue
            }
            
            let bar = bars[index]
            let bezPath = UIBezierPath()
            
            let xVal = bar.frame.origin.x + bar.frame.size.width / 2
            let yVal = self.graphDimensions.height
            
            bezPath.moveToPoint(CGPointMake(xVal, yVal))
            bezPath.addLineToPoint(CGPointMake(xVal, yVal + 3))
            
            let layer = CAShapeLayer()
            layer.path = bezPath.CGPath;
            layer.fillColor = self.tickFillColor.CGColor;
            layer.strokeColor = self.tickStrokeColor.CGColor;
            
            view.layer.addSublayer(layer)
            
            //Okay those are the ticks. Now we need the labels
            
            if(tickFormat == nil)
            {
                //TODO: REturn some sort of error if tickformat is nil
                return nil
            }
            
            let tickLabel = UILabel()
            tickLabel.text = tickFormat!(CGFloat(index));
            tickLabel.sizeToFit()
            
            let textWidth = tickLabel.frame.size.width
            let textHeight = tickLabel.frame.size.height
            
            tickLabel.textAlignment = .Center;
            
            if(index == 0 && xVal == 0)
            {
                tickLabel.frame = CGRectMake(xVal - 2, 0, textWidth, textHeight)
                tickLabel.textAlignment = .Left
            }
            else if(index == self.ticks && xVal == labelView.frame.size.width)
            {
                tickLabel.frame = CGRectMake(xVal - textWidth + 2, 0, textWidth, textHeight)
                tickLabel.textAlignment = .Right
            }
            else
            {
                tickLabel.frame = CGRectMake( xVal - textWidth/2, 0, textWidth, textHeight)
                tickLabel.textAlignment = .Center
            }
            
            tickLabel.font = self.tickFont;
            tickLabel.textColor = self.tickLabelColor;
            labelView.addSubview(tickLabel)
        }
            
        labelView.alpha = 0.0
        
        view.addSubview(labelView)
        
        UIView.animateWithDuration(1) { () -> Void in
            labelView.alpha = 1.0
        }
        
        return labelView;
    }

}