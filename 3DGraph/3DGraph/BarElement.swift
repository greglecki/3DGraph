//
//  BarElement.swift
//  3DGraph
//
//  Created by Greg Lecki on 27/08/2015.
//  Copyright (c) 2015 Greg Lecki. All rights reserved.
//

import UIKit


/// Single bar element to be added to barElements array in GraphView

class BarElement: NSObject {

    private(set) var width: CGFloat = 10
    private(set) var height: CGFloat = 10
    private(set) var color: UIColor
    private(set) var cornerRadius: CGFloat
    
    /// Use internally by library. DON'T set the value manually.
    var index = 0
    
    /// Leght of the bar
    var length: CGFloat = 10
    
    /// Array of labels - each element in the array is draw in a separate line
    var labels: [NSAttributedString]?
    
    /**
    Initializes a new bar element with the provided pameters.
    
    :param: width with of the bar element
    :param: height height of the bar element
    :param: length length of the bar element
    :param: color color of the bar element
    :param: cornerRadius corner radius of the bar element represented in units not pixel
    
    :returns: A new bar element.
    */
    init(width: CGFloat = 10, height: CGFloat = 10, length: CGFloat = 10, color: UIColor = UIColor.grayColor(), cornerRadius: CGFloat = 0.5) {
        
        self.width = width
        self.height = height
        self.length = length
        self.color = color
        self.cornerRadius = cornerRadius
        
        super.init()
        
    }
}
