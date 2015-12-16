//
//  FNKBar.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation
import UIKit

class FNKBar: UIView
{
    let originalFrame: CGRect
    var heightConstraint: NSLayoutConstraint?
    
    init(frame: CGRect) {
        self.originalFrame = frame
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {

    }
        
    func updateBar(expand: Bool)
    {
        if(expand)
        {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.frame = CGRectMake(self.frame.origin.x, self.originalFrame.origin.y, self.frame.size.width, self.originalFrame.size.height);
                self.alpha = 0.7
                }, completion: { (completed) -> Void in
                    
            })
        }
        else
        {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.frame = CGRectMake(self.frame.origin.x, self.originalFrame.origin.y, self.frame.size.width, self.originalFrame.size.height);
                self.alpha = 0.2;
                }, completion: { (completed) -> Void in
                    
            })
        }
    
    }
}