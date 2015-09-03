//
//  LabelNode.swift
//  3DGraph
//
//  Created by Greg Lecki on 01/09/2015.
//  Copyright (c) 2015 Greg Lecki. All rights reserved.
//

import UIKit
import SceneKit

class LabelNode: SCNNode {

    private var text: NSAttributedString

    init(text: NSAttributedString) {
        
        self.text = text
        
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func getLabel() -> SCNNode? {
        
        var textNode = SCNNode()
        
        if text.length < 1 { return nil }
        
        var range = NSMakeRange(0, 1)
        
        let myText = SCNText(string: text, extrusionDepth: 0.1)
        myText.alignmentMode = kCAAlignmentRight
        
        if let color = text.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange:&range) as? UIColor {
            myText.firstMaterial!.diffuse.contents = color
        }
        
        myText.firstMaterial!.specular.contents = UIColor.whiteColor()
        let myTextNode = SCNNode(geometry: myText)

        myTextNode.orientation = SCNQuaternion(x: 0.1, y: 0, z: 0, w: 0)
        
        textNode.addChildNode(myTextNode)
        
        return textNode
        
    }
}
