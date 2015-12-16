//
//  FNKGraphsViewController.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation
import UIKit

class FNKGraphsViewController: UIViewController, UIGestureRecognizerDelegate
{
    let marginLeft: CGFloat
    let marginBottom: CGFloat
    let graphDimensions: CGRect
    var hasDrawn: Bool = false
    
    var graphData: [CGFloat]?
    var dataArray: Array<AnyObject>?
    
    weak var delegate: FNKChartsViewDelegate?
//    var chartOverlay: FNKChartOverlayBars
    
    convenience init(frame: CGRect)
    {
        self.init(rect: frame, marginLeft: 20, marginBottom: 5, graphWidth: frame.size.width - 20, graphHeight: (frame.size.height - 5))
    }
    
    
    init(rect:CGRect, marginLeft:CGFloat, marginBottom:CGFloat, graphWidth:CGFloat, graphHeight:CGFloat)
    {
        self.marginLeft = marginLeft;
        self.marginBottom = marginBottom;
        self.graphDimensions =  CGRect(x: 0, y: 0, width: graphWidth, height: graphHeight)
//        self.drawBars = false;
        super.init(nibName: nil, bundle: nil)
        self.initializers()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    
    func initializers()
    {
    
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        self.view.userInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target:self, action:"handlePan")
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:"handleTap")
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    func drawGraph(completion: ((Void) -> Void)?)
    {
        //TODO: Really shouldn't have to do this
//        self.graphHeight = self.view.frame.size.height - self.marginBottom
//        self.graphWidth = self.view.frame.size.width - self.marginLeft
    }
    
    
//    -(void)handleTap:(UITapGestureRecognizer*)recognizer
//    {
//        CGPoint point = [recognizer locationInView:self.view];
//        
//        [self handleGesture:point];
//    }
}