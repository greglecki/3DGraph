//
//  BarNode.swift
//  3DGraph
//
//  Created by Greg Lecki on 27/08/2015.
//  Copyright (c) 2015 Greg Lecki. All rights reserved.
//

import UIKit
import SceneKit


class BarNode: SCNNode {
    
    var width: CGFloat = 10
    var height: CGFloat = 10
    private(set) var color: UIColor
    private(set) var cornerRadius: CGFloat
    private var bar: SCNBox!
    private var barNode: SCNNode!
    private var textNode: SCNNode?
    var labelOffset: CGPoint = CGPointZero
    
    var index = 0
    
    var length: CGFloat = 10 /*{
        didSet {
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            bar.length = length
            barNode.pivot = SCNMatrix4MakeTranslation(0, 0, Float(-length/2))
            
            if let textNode = textNode {
                textNode.pivot = SCNMatrix4MakeTranslation(0, 0, Float(-length/2))
            }
            SCNTransaction.commit()
        }
    }*/
    
    var labels: [NSAttributedString]? /*{
        didSet {
            addLabels(labels?.reverse())
        }
    }*/
    
    init(width: CGFloat = 10, height: CGFloat = 10, length: CGFloat = 10, color: UIColor = UIColor.grayColor(), cornerRadius: CGFloat = 0.5) {
        
        self.width = width
        self.height = height
        self.length = length
        self.color = color
        self.cornerRadius = cornerRadius
        
        super.init()

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func prepareBarNode() {

        barNode = SCNNode(geometry: createBar(width, height: height, length: length, color: color, cornerRadius: cornerRadius))
        barNode.pivot = SCNMatrix4MakeTranslation(0, 0, Float(-length/2))
        
        addLabels(labels?.reverse())
        
        addChildNode(barNode)
    }
    
    func setLength(length: CGFloat, animated: Bool) {

        let duration: CFTimeInterval = animated ? 0.5 : 0.0
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(duration)
        
        bar.length = length
        barNode.pivot = SCNMatrix4MakeTranslation(0, 0, Float(-length/2))
        
        if let textNode = textNode {
            textNode.pivot = SCNMatrix4MakeTranslation(0, 0, Float(-length/2))
        }
        SCNTransaction.commit()
    }
    
    private func createBar(width: CGFloat, height: CGFloat, length: CGFloat, color: UIColor, cornerRadius: CGFloat) -> SCNBox {
        
        let geometry = SCNBox(width: width, height: height, length: length, chamferRadius: cornerRadius)
        geometry.firstMaterial!.diffuse.contents = color
        geometry.firstMaterial!.specular.contents = UIColor.whiteColor()
        bar = geometry
        
        return geometry
    }
    
    private func addLabels(labels: [NSAttributedString]?) {
        
        if let labels = labels {
            
            textNode = SCNNode()
            
            let space = height*0.8 / CGFloat(labels.count)
            var yPoint = (-height/2) + (space/2)
            
            for attString in labels {
                
                if attString.length < 1 { return }
                
                var range = NSMakeRange(0, 1)
                
                let myText = SCNText(string: attString, extrusionDepth: 0.1)
                myText.alignmentMode = kCAAlignmentRight
                if let color = attString.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange:&range) as? UIColor {
                    myText.firstMaterial!.diffuse.contents = color
                }
                
                myText.firstMaterial!.specular.contents = UIColor.whiteColor()
                let myTextNode = SCNNode(geometry: myText)
                
                myTextNode.position = SCNVector3(x: Float(-attString.size().width + width*0.9/2 + labelOffset.x), y: Float(yPoint + labelOffset.y), z: 0)
                myTextNode.orientation = SCNQuaternion(x: 0.1, y: 0, z: 0, w: 0)
                
                textNode?.addChildNode(myTextNode)
                
                yPoint += space
            }

            textNode!.pivot = SCNMatrix4MakeTranslation(0, 0, Float(-length/2))
            barNode.addChildNode(textNode!)
        }
    }
}

