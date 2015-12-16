//
//  FNKYAxis.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

class FNKYAxis: FNKAxis
{
    let tickType: FNKYAxisTickType
    let paddingPercentage: Float
    
    init(marginLeft: CGFloat, marginBottom: CGFloat, scaleFactor: CGFloat, axisMin: CGFloat, tickType: FNKYAxisTickType,paddingPercentage: Float, graphDimensions: CGRect)
    {
        self.tickType = tickType
        self.paddingPercentage = paddingPercentage
        super.init(marginLeft: marginLeft, marginBottom: marginBottom, scaleFactor: scaleFactor, axisMin: axisMin, graphDimensions: graphDimensions)
    }
    
    override func drawAxis(view: UIView) {
        
        let bezPath = UIBezierPath()
        bezPath.moveToPoint(CGPointMake(self.graphDimensions.width, 0))
        bezPath.addLineToPoint(CGPointMake(self.marginLeft, self.graphDimensions.height))
        bezPath.closePath()
        
        let layer = CAShapeLayer()
        layer.path = bezPath.CGPath
        layer.fillColor = self.fillColor.CGColor
        layer.strokeColor = self.strokeColor.CGColor
        
        view.layer.addSublayer(layer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        
        layer.addAnimation(pathAnimation, forKey: "strokeEnd")
        
        //Draw all lines
        let tickInterval = self.graphDimensions.height / CGFloat(self.ticks)
        for index in 0...self.ticks+1
        {
            let bezPath = UIBezierPath()
            
            let xVal = self.marginLeft
            let yVal = CGFloat(index) * tickInterval
            
            bezPath.moveToPoint(CGPointMake(xVal, yVal))
            
            if(self.tickType == .Outside)
            {
                bezPath.addLineToPoint(CGPointMake(self.graphDimensions.width, yVal))
            }
            else if(self.tickType == .Behind)
            {
                bezPath.addLineToPoint(CGPointMake(xVal + self.graphDimensions.width, yVal))
            }
            else if(self.tickType == .Above)
            {
                bezPath.addLineToPoint(CGPointMake(xVal + self.graphDimensions.width, yVal))
            }
            
            let layer  = CAShapeLayer()
            layer.path = bezPath.CGPath
            layer.fillColor = self.tickFillColor.CGColor
            layer.strokeColor = self.tickStrokeColor.CGColor
            
            view.layer.addSublayer(layer)
            
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = self.animationDuration
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1.0
            
            layer.addAnimation(pathAnimation, forKey:"strokeEnd")
        }
    }
    
    override func addTicksToView(view: UIView, tickFormat: (CGFloat) -> (String)) -> UIView?
    {
        let tickInterval = self.graphDimensions.height / CGFloat(self.ticks)
        
        let labelView = UIView(frame:CGRectMake(0, 0, 40,  view.frame.size.height))
        labelView.alpha = 0.0
        view.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        let labelViewMap = ["labelView" :labelView]
        
        if(self.tickType == .Behind)
        {
            let widthConstraints = NSLayoutConstraint.constraintsWithVisualFormat(String(format: "|-0-[labelView(%ld)]", arguments: [self.marginLeft]), options: .AlignmentMask, metrics: nil, views: labelViewMap)
                
            view.addConstraints(widthConstraints)
        }
        else if(self.tickType == .Above)
        {
            let widthConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-0-[labelView]",
            options:.AlignmentMask,
            metrics:nil,
            views:labelViewMap)
            view.addConstraints(widthConstraints)
        }
        
        let heightConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[labelView]-0-|", options:.AlignmentMask, metrics:nil, views:labelViewMap)
        view.addConstraints(heightConstraints)
        
        view.layoutSubviews()
        
        for index in 0...self.ticks
        {
            if (index == self.ticks)
            {
                continue
            }
        
            let yLoc = self.tickType == .Above ? (CGFloat(index) * tickInterval) - self.tickFont.capHeight :  (CGFloat(index) * tickInterval);
            let yVal = self.tickType == .Above ? (CGFloat(index) * tickInterval) :  (CGFloat(index) * tickInterval);
            
            //Okay those are the ticks. Now we need the labels
            let tickLabel = UILabel()
            
            let originalVal = ((self.graphDimensions.height - yVal) / self.scaleFactor) + self.axisMin
            tickLabel.text = tickFormat(originalVal) 
            
            if(self.tickType == .Above)
            {
                tickLabel.textAlignment = .Left;
            }
            else
            {
                tickLabel.textAlignment = .Right;
            }
        
            tickLabel.font = self.tickFont
            tickLabel.textColor = self.tickLabelColor
            tickLabel.adjustsFontSizeToFitWidth = true
            tickLabel.minimumScaleFactor = 0.5
            tickLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            labelView.addSubview(tickLabel)
            
            tickLabel.translatesAutoresizingMaskIntoConstraints = false
            let labelViewMap = ["labelView" :labelView]
            
            var constraintString: String
            if(self.tickType == .Above)
            {
                constraintString = String("|-(%f)-[tickLabel]-2-|", self.marginLeft)
            }
            else
            {
                constraintString = "|-0-[tickLabel]-2-|"
            }
        
            let widthConstraints = NSLayoutConstraint.constraintsWithVisualFormat(constraintString, options:.AlignmentMask, metrics:nil, views:labelViewMap)
            labelView.addConstraints(widthConstraints)
            
            //TODO: This is a bit of a hack since I don't know what the height of the label is actually going to be
            constraintString = String("V:|-(%f)-[tickLabel]", yLoc - 5)
            let heightConstraints = NSLayoutConstraint.constraintsWithVisualFormat(constraintString, options:.AlignmentMask, metrics:nil, views:labelViewMap)
            labelView.addConstraints(heightConstraints)
            
            labelView.layoutSubviews()
        }

        UIView.animateWithDuration(1.0) { () -> Void in
            labelView.alpha = 1.0
        }
        
        return labelView;
    }
}