//
//  FNKGraphsBarGraphViewController.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

class FNKGraphsBarGraphViewController : FNKGraphsDualAxisGraph
{
    static let FNKMinBarWidth: CGFloat = 0.5
    
    /* The label that will show up for the specific object in the graph data */
//    @property (nonatomic, copy) CGFloat (^labelValueForObject)(id object);
    private var labelValueForObject: ((object: AnyObject!) -> String)
    
    /* The value for the specific object in the graph data (the length of the bar)*/
//    @property (nonatomic, copy) CGFloat (^valueForObject)(id object);
    private var valueForObject: ((object: AnyObject!) -> CGFloat)?
    
    /* The color for the specfic bar given the object */
//    @property (nonatomic, copy) UIColor* (^colorForBar)(int object);
    private var colorForBar: ((object: AnyObject!) -> UIColor!)?
    
    /* The padding between each of the bars (defaults 5)*/
    var barPadding: CGFloat = 5
    
    /* The corner radius for each bars (defaults 0)*/
    var barCornerRadius: CGFloat = 0
    
    /* The time bucket that this object will fit into*/
//    @property (nonatomic, copy) void (^barAdded)(FNKBar* bar, int barNum);
    private var barAdded: ((bar: FNKBar!, barNum:Int) -> Void)?
    
    private var yScaleFactor: CGFloat
    private var yRange: CGFloat
    private var barWidth: CGFloat
    private var barsArray: [FNKBar]

    override func drawGraph(completion: ((Void) -> Void)?)
    {
        if(self.dataArray == nil || self.valueForObject == nil)
        {
            //TODO: Throw error
        }
        
        super.drawGraph(completion)

        self.graphData = []

        //Convert all of the data to be sectionData
        for data in self.dataArray!
        {
            self.graphData!.append(self.valueForObject!(object: data))
        }

        self.drawAxii(self.view)
        self.calcMaxMin(self.graphData!)

        //There are a couple of steps here
        //First we need to figure out the width of the bars
        self.barWidth = (self.graphDimensions.width / CGFloat(self.graphData!.count)) - self.barPadding

        if(self.barWidth < FNKGraphsBarGraphViewController.FNKMinBarWidth)
        {
            self.barWidth = FNKGraphsBarGraphViewController.FNKMinBarWidth

            self.barPadding = (self.graphDimensions.width / CGFloat(self.graphData!.count)) - self.barWidth
        }

        self.addTicks()

        self.barsArray = []

        var index = 0;

        let animationGroup = dispatch_group_create()

        for barData in self.graphData!
        {
            //Ensure there is at least some padding
            let x = CGFloat(index) * (self.barWidth + self.barPadding) + self.barPadding

            let barView = FNKBar(frame: CGRectMake(x + self.marginLeft, self.graphDimensions.height, self.barWidth, 0))

            barView.layer.cornerRadius = self.barCornerRadius

            barView.backgroundColor = self.colorForBar?(object: index)
            barView.alpha = 1.0
            
            barView.heightConstraint = NSLayoutConstraint.constraintWithItem(barView, attribute:.Height, relatedBy:.Equal, toItem:nil, attribute:.NotAnAttribute, multiplier:0.0, constant:0.0)
            

            barView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(barView)
            self.view.addConstraint(barView.heightConstraint)
            self.view.addConstraint(NSLayoutConstraint.constraintWithItem(barView, attribute: .Left, relatedBy: .Equal, toItem:self.view, attribute: .Left, multiplier:1.0, constant:x + self.marginLeft))
            
            self.view.addConstraint(NSLayoutConstraint.constraintWithItem(barView, attribute: .Bottom, relatedBy:. Equal, toItem: self.view, attribute: .Bottom, multiplier:1.0, constant:-self.marginBottom))

            self.view.addConstraint(NSLayoutConstraint.constraintWithItem(barView, attribute: .Width, relatedBy: .Equal, toItem:nil, attribute: .NotAnAttribute, multiplier:1.0, constant:self.barWidth))

            self.barsArray.addObject(barView)

            self.view.insertSubview(barView, belowSubview:self.yLabelView)

            self.barAdded?(bar: barView, barNum: index)

            let delay = 0.05 * NSTimeInterval(index)

            dispatch_group_enter(animationGroup)

            weak var weakSelf = self
            
            UIView.animateWithDuration(1, delay: delay, options: .CurveEaseIn, animations: { () -> Void in
                    if(weakSelf != nil)
                    {
                        barView.heightConstraint?.constant = barData * weakSelf!.yScaleFactor
                        weakSelf!.view.layoutSubviews()
                    }
                }, completion: { (finished) -> Void in
                    dispatch_group_leave(animationGroup);
            })
            
            index++
        }

        weak var weakSelf = self;
        self.xLabelView = self.xAxis.addTicksToView(self.view, bars: self.barsArray) { (index) -> String in
            if(weakSelf != nil)
            {
                let objc = weakSelf!.dataArray![index]
                return weakSelf!.labelValueForObject(object: objc)
            }
        }

        dispatch_group_notify(animationGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            completion?()
        }
    }

    func drawAxii(view: UIView)
    {
        self.yAxis.drawAxis(view)

        self.xAxis.drawAxis(view)
    }

    func addTicks()
    {
        self.yLabelView = self.yAxis.addTicksToView(self.view)
    }

    func removeTicks()
    {
        self.yLabelView?.removeFromSuperview()
        self.xLabelView?.removeFromSuperview()
    }

    func transitionBar(data: [CGFloat], duration: NSTimeInterval, completion: ((Void) -> (Void))?)
    {
        let animationGroup = dispatch_group_create()
        var i = 0
        
        for bar in self.barsArray
        {
            let barData = data[i]

            dispatch_group_enter(animationGroup)
            weak var weakSelf = self
            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                if(weakSelf != nil)
                {
                    bar.heightConstraint?.constant = barData * weakSelf!.yScaleFactor
                    self.view.layoutSubviews()
                }
                }, completion: { (finished) -> Void in
                    dispatch_group_leave(animationGroup)
            })
            
            i++
        }
        dispatch_group_notify(animationGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            completion?()
        }
    }

    func calcMaxMin(buckets: [CGFloat])
    {
        var maxY = CGFloat.NaN
        var minY = CGFloat.infinity

        for data in buckets
        {
            if(data > maxY)
            {
                maxY = data
            }

            if(data < minY)
            {
                minY = data
            }
        }

        //If the user has defined a yMin then we shoudl use that.
        //This allows us to have the value start at 0.
        if(self.yAxis.overridingMin != nil && self.yAxis.overridingMin! < minY)
        {
            minY = self.yAxis.overridingMin!
        }

        if(self.yAxis.overridingMax != nil && self.yAxis.overridingMax! > maxY)
        {
            maxY = self.yAxis.overridingMax!
        }

        //Okay so now we have the min's and max's
        self.yRange = maxY - minY;

        self.yScaleFactor = self.graphDimensions.height / self.yRange;

        self.yAxis.scaleFactor = self.yScaleFactor
        self.yAxis.axisMin = minY
    }

    /* Provides ability to pass in a value and determines where it would end up on the graph */
    func scaleYValue(value: Double) -> Double
    {
        return value * Double(self.yScaleFactor)
    }

    /* When using the bar graph in a UITableViewCell you might have to reset the bar colors when the cell is clicked*/
    func resetBarColors()
    {
        for bar in self.barsArray
        {
            bar.backgroundColor = self.colorForBar?(object: bar)
        }
    }
}