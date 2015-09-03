//
//  ViewController.swift
//  3DGraph
//
//  Created by Greg Lecki on 03/09/2015.
//  Copyright (c) 2015 Greg Lecki. All rights reserved.
//

import UIKit

import SceneKit


class ViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        graphView.barElements = getBars()
        graphView.selectedItemHandler = {
            idx in
            println("Item \(idx) pressed")
        }
        
        graphView.xAxisLabels = getHorizontalLabels()
        graphView.xLabelsOnTop = false
        
        graphView.yAxisLabels = getVerticalLabels()
        graphView.yLabelsOnLeft = false
        
        //graphView.columns = 4
        //graphView.offset = CGPoint(x: 0, y: -60)
        //graphView.labelOffset = CGPoint(x: -10, y: 5)
        //graphView.rotAngleX = -60
        //graphView.rotAngleY = -18
        
    }
    
    @IBAction func columnsPressed(sender: AnyObject) {
        
        graphView.columns = graphView.columns == 3 ? 4 : 3
    }
    
    @IBAction func horSpaceButtonPressed(sender: AnyObject) {
        graphView.horizontalSpace = graphView.horizontalSpace == 2 ? 4 : 2
    }
    
    @IBAction func vertSpaceButtonPressed(sender: AnyObject) {
        graphView.verticalSpace = graphView.verticalSpace == 2 ? 4 : 2
    }
    
    @IBAction func animationButtonPressed(sender: AnyObject) {
        
        graphView.setBarLength(150, atIndex: 0, animated: true)
        graphView.setBarLength(80, atIndex: 2, animated: true)
        graphView.setBarLength(70, atIndex: 5, animated: true)
    }
    
    // MARK: - TEST Methods
    func getBars() -> [BarElement] {
        
        var label1 = NSMutableAttributedString(string: "Count 76")
        label1.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(4), NSForegroundColorAttributeName: UIColor.whiteColor()], range: NSMakeRange(0, 5))
        label1.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(4.5)], range: NSMakeRange(5, label1.length-5))
        
        var label2 = NSMutableAttributedString(string: "Value 663.4k")
        label2.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(4), NSForegroundColorAttributeName: UIColor.whiteColor()], range: NSMakeRange(0, 5))
        label2.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(4.5)], range: NSMakeRange(5, label2.length-5))
        
        var label3 = NSMutableAttributedString(string: "Avg demand 178.9k")
        label3.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(4), NSForegroundColorAttributeName: UIColor.whiteColor()], range: NSMakeRange(0, 10))
        label3.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(4.5)], range: NSMakeRange(10, label3.length-10))
        
        var label4 = NSMutableAttributedString(string: "Fill(90.04%) 91.96%")
        label4.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(4), NSForegroundColorAttributeName: UIColor.whiteColor()], range: NSMakeRange(0, 12))
        label4.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(4.5)], range: NSMakeRange(12, label4.length-12))
        
        let bar1 = BarElement(width: 200, height:150, length: 200, color: UIColor.orangeColor(), cornerRadius: 1.5)
        bar1.labels = [label1, label2, label3, label4]
        
        let bar2 = BarElement(width: 200, height: 150, length: 150, color: UIColor.redColor(), cornerRadius: 1.5)
        bar2.labels = [label1, label2, label3, label4]
        
        let bar3 = BarElement(width: 200, height: 150, length: 180, color: UIColor.blueColor(), cornerRadius: 1.5)
        bar3.labels = [label1, label2, label3, label4]
        
        let bar4 = BarElement(width: 200, height: 150, length: 140, color: UIColor.orangeColor(), cornerRadius: 1.5)
        let bar5 = BarElement(width: 200, height: 150, length: 100, color: UIColor.blueColor(), cornerRadius: 1.5)
        let bar6 = BarElement(width: 200, height: 150, length: 120, color: UIColor.redColor(), cornerRadius: 1.5)
        let bar7 = BarElement(width: 200, height: 150, length: 80, color: UIColor.redColor(), cornerRadius: 1.5)
        let bar8 = BarElement(width: 200, height: 150, length: 60, color: UIColor.orangeColor(), cornerRadius: 1.5)
        let bar9 = BarElement(width: 200, height: 150, length: 100, color: UIColor.blueColor(), cornerRadius: 1.5)
        
        return [bar1, bar2, bar3, bar4, bar5, bar6, bar7, bar8, bar9]
    }
    
    func getHorizontalLabels() -> [NSAttributedString] {
        var labelX1 = NSMutableAttributedString(string: "Low")
        labelX1.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(5), NSForegroundColorAttributeName: UIColor.darkGrayColor()], range: NSMakeRange(0, 3))
        
        var labelX2 = NSMutableAttributedString(string: "Medium")
        labelX2.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(5), NSForegroundColorAttributeName: UIColor.darkGrayColor()], range: NSMakeRange(0, 6))
        
        var labelX3 = NSMutableAttributedString(string: "High")
        labelX3.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(5), NSForegroundColorAttributeName: UIColor.darkGrayColor()], range: NSMakeRange(0, 4))
        
        var labelX4 = NSMutableAttributedString(string: "Very High")
        labelX4.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(5), NSForegroundColorAttributeName: UIColor.darkGrayColor()], range: NSMakeRange(0, 9))
        
        return [labelX1, labelX2, labelX3, labelX4]
    }
    
    func getVerticalLabels() -> [NSAttributedString] {
        var labelY1 = NSMutableAttributedString(string: "A")
        labelY1.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(5), NSForegroundColorAttributeName: UIColor.darkGrayColor()], range: NSMakeRange(0, 1))
        
        var labelY2 = NSMutableAttributedString(string: "B")
        labelY2.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(5), NSForegroundColorAttributeName: UIColor.darkGrayColor()], range: NSMakeRange(0, 1))
        
        var labelY3 = NSMutableAttributedString(string: "C")
        labelY3.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(5), NSForegroundColorAttributeName: UIColor.darkGrayColor()], range: NSMakeRange(0, 1))
        return [labelY1, labelY2, labelY3]
    }
}

