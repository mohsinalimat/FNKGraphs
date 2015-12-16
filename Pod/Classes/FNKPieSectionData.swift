//
//  FNKPieSectionData.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

class FNKPieSectionData
{
    let percentage: Float
    let name: String
    let color: UIColor
    let sliceValue: Float
    
    var slice: CAShapeLayer?
    var sliceLabel: UILabel?
    
    init(name: String, color: UIColor, percentage: Float, sliceValue: Float)
    {
        self.name = name
        self.color = color
        self.percentage = percentage
        self.sliceValue = sliceValue
    }

}