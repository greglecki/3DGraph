//
//  GraphView.swift
//  3DGraph
//
//  Created by Greg Lecki on 26/08/2015.
//  Copyright (c) 2015 Greg Lecki. All rights reserved.
//

import UIKit
import SceneKit


let MINRANGE: CGFloat = 0
let MAXRANGE: CGFloat = 60

/// Place where the graph will be displayed
class GraphView: UIView {

    private var sceneView: SCNView!
    private var mainNode: SCNNode = SCNNode()
    private var barNodes = [BarNode]()
    private var minRange: CGFloat = 0
    private var maxRange: CGFloat = 0
    private var animated = false
    
    /// If rotateAtTapEnabled is true that's amount of degree the bar will rotate around the X Axis when user tapped the graph view
    var rotAngleX: CGFloat = -35.0
    /// If rotateAtTapEnabled is true that's amount of degree the bar will rotate around the Y Axis when user tapped the graph view
    var rotAngleY: CGFloat = -5.0

    /// Enable rotation of the graph view on touch, the default is true
    var rotateAtTapEnabled = true
    /// Handler which is triggered after user touch bar element
    var selectedItemHandler: ((Int) -> ())?

    /// Labels describe the X Axis
    var xAxisLabels: [NSAttributedString]? {
        didSet {
            drawGraph()
        }
    }

    /// Labels describe the Y Axis
    var yAxisLabels: [NSAttributedString]? {
        didSet {
            drawGraph()
        }
    }
    
    /// Set the X Axis labels on the top of the graph, the default is true. Set to false if you want to move it to the bottom
    var xLabelsOnTop = true {
        didSet {
            drawGraph()
        }
    }
    
    /// Set the Y Axis labels on the left of the graph, the default is true. Set to false if you want to move it to the right
    var yLabelsOnLeft = true {
        didSet {
            drawGraph()
        }
    }

    /// Array of BarElements which will be draw on the graph
    var barElements = [BarElement]() {
        didSet {
            drawGraph()
        }
    }
    
    /// Number of bar elements in one row
    var columns: Int = 3 {
        didSet {
            drawGraph()
        }
    }
    
    /// Horizontal space betweene each bar element
    var horizontalSpace: Float = 2 {
        didSet {
            drawGraph()
        }
    }
    
    /// Vertical space betweene each bar element
    var verticalSpace: Float = 2 {
        didSet {
            drawGraph()
        }
    }
    
    /// The graph position offset, the default is CGPointZero (centre of the view). Change the offset is you want to move in relation to the view
    var offset: CGPoint = CGPointZero {
        didSet {
            offset = translatePointTo3DWorld(offset)
            drawGraph()
        }
    }
    
    /// BarElement's labels offset, the default is CGPointZero. Change the offset is you want to move in relation to the bar element
    var labelOffset: CGPoint = CGPointZero {
        didSet {
            labelOffset = translatePointTo3DWorld(labelOffset)
            drawGraph()
        }
    }

    // MARK: - UIVIew Lifecycle
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        prepareGraphView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        prepareGraphView()
    }
    
    override var bounds: CGRect {
        didSet {
            //println("Size: \(NSStringFromCGRect(bounds))")
            sceneView.frame = bounds
            if let _ = mainNode.parentNode  {
                drawGraph()
            }
        }
    }

    // MARK: - Custom Methods
    /**
    Changes single bar element length with animation, which could be disabled
    
    :param: length The new length of the bar element
    :param: atIndex index of bar element you want to change the length
    :param: animated animate the change  if set to true
    */
    func setBarLength(length: CGFloat, atIndex index: Int, animated: Bool = true) {

        var newLength = length
        if length > maxRange {
            newLength = maxRange
        }
        if length < minRange {
            newLength = minRange
        }
        if let node = barNodes.filter( { $0.index == index } ).first {
            let val = getNewValue(newLength, min: minRange, max: maxRange)
            node.setLength(val, animated: animated)
        }
    }
    
    /**
    Changes all bar elements length with animation, which could be disabled
    
    :param: lengths Array of the new lengths. Array count needs to match bar elements count added to the graph view
    :param: animated animate the change  if set to true
    */
    func reloadBarLengths(lengths: [CGFloat], animated: Bool = true) {

        if lengths.count < barNodes.count {
            println("ReloadBarLengths: array of lengths must be the same length as bar elements count passed to graph view")
            return
        }
        
        minRange = 0
        maxRange = 0
        for len in lengths {
            if len > maxRange {
                maxRange = len
            }
            if len < minRange {
                minRange = len
            }
        }
        
        for idx in 0..<barNodes.count {
            if let node = barNodes.filter( { $0.index == idx } ).first {
                let val = getNewValue(lengths[idx], min: minRange, max: maxRange)
                node.setLength(val, animated: animated)
            }
        }
    }
    
    private func prepareGraphView() {
        
        scnViewSetup()
        sceneSetup()
        setupCamera()
    }
    
    private func scnViewSetup() {
        
        //sceneView = SCNView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        
        sceneView = SCNView(frame: bounds)
        sceneView.backgroundColor = UIColor.clearColor()

        addSubview(sceneView)
    }
    
    private func sceneSetup() {
        
        let scene = SCNScene()
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLightTypeOmni
        omniLightNode.light!.color = UIColor(white: 0.30, alpha: 1.0) //0.75
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapGesture:")
        sceneView.addGestureRecognizer(tapRecognizer)
        
        sceneView.scene = scene
    }
    
    private func setupCamera() {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 105)
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 80
        cameraNode.camera?.automaticallyAdjustsZRange = true
        
        sceneView.scene?.rootNode.addChildNode(cameraNode)
    }
    
    private func drawGraph() {

        if barElements.count > 0 {
            
            minRange = 0
            maxRange = 0
            for b in barElements {
                if b.length > maxRange {
                    maxRange = b.length
                }
                if b.length < minRange {
                    minRange = b.length
                }
            }

            barNodes = barElements.map {
                [unowned self] (bar) -> BarNode in
                
                let newSize = self.translateSizeTo3DWorld(CGSize(width: bar.width, height: bar.height))
                let barNode = BarNode(width: newSize.width, height: newSize.height, length:self.getNewValue(bar.length, min: self.minRange, max: self.maxRange), color: bar.color, cornerRadius: bar.cornerRadius)
                barNode.labels = bar.labels
                
                barNode.index = bar.index
                barNode.labelOffset = self.labelOffset
                barNode.prepareBarNode()

                return barNode
            }

            let graph = GraphNode(barNodes: barNodes, columns: columns)
            graph.horizontalSpace = horizontalSpace
            graph.verticalSpace = verticalSpace
            
            graph.xAxisLabels = xAxisLabels
            graph.yAxisLabels = yAxisLabels
            graph.xLabelsOnTop = xLabelsOnTop
            graph.yLabelsOnLeft = yLabelsOnLeft
            
            graph.reDrawGraph()

            graph.pivot = SCNMatrix4MakeTranslation(graph.position.x - Float(offset.x), graph.position.y - Float(offset.y), 0)
            
            mainNode.removeFromParentNode()

            mainNode = graph
            sceneView.scene!.rootNode.addChildNode(mainNode)
        }
    }


    // MARK - Gesture Recognizer
    func tapGesture(sender: UITapGestureRecognizer) {
        
        if (!rotateAtTapEnabled && selectedItemHandler == nil) {
            return
        }
        if !animated {
            
            let vp = sender.locationInView(sceneView)
            
            if let node = getNodeAtPoint(vp) {
                if let handler = selectedItemHandler {
                    handler(node.index)
                }
                // Dont animate call itemSelected block
                return
            }
        }

        rotateGraph()
    }


    // MARK - Animation Delegate
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {

        var rotX = rotAngleX
        var rotY = rotAngleY
        if animated {
            rotX = 0.0
            rotY = 0.0
        }
        if (flag) {
            mainNode.transform = SCNMatrix4Mult(SCNMatrix4MakeRotation(Float(degreeToRadian(rotX)), 1, 0, 0), SCNMatrix4MakeRotation(Float(degreeToRadian(rotY)), 0, 1, 0))
            mainNode.removeAllAnimations()
            animated = !animated
        }
    }


    // MARK: - Helpers
    private func getNodeAtPoint(point: CGPoint) -> BarNode? {

        let worldPoint = mapPointTo3DWorld(point)
        
        var nodes = mainNode.childNodesPassingTest { (child, stop) -> Bool in
            if let n = child as? BarNode {

                let nodeRect = CGRect(x: CGFloat(n.position.x) + self.offset.x - n.width/2, y: CGFloat(n.position.y) + self.offset.y - n.height/2, width: n.width, height: n.height)
                
                if CGRectContainsPoint(nodeRect, CGPoint(x: CGFloat(worldPoint.x), y: CGFloat(worldPoint.y))) {
                    return true
                }
            }
            return false
        }

        return nodes.first as? BarNode
    }
    
    private func translatePointTo3DWorld(point: CGPoint) -> CGPoint {
        
        let viewSize = bounds
        
        let p = mapPointTo3DWorld(CGPoint(x: viewSize.width, y: viewSize.height))
        
        let widthRatio = viewSize.width / (abs(p.x)*2)
        let heightRatio = viewSize.height / (abs(p.y)*2)
        
        return CGPoint(x: point.x/widthRatio, y: point.y/heightRatio)
    }
    
    private func translateSizeTo3DWorld(size: CGSize) -> CGSize {

        let viewSize = bounds
        
        let p = mapPointTo3DWorld(CGPoint(x: viewSize.width, y: viewSize.height))
        
        let widthRatio = viewSize.width / (abs(p.x)*2)
        let heightRatio = viewSize.height / (abs(p.y)*2)
        
        return CGSize(width: size.width/widthRatio, height: size.height/heightRatio)
    }
    
    private func mapPointTo3DWorld(point: CGPoint) -> CGPoint {

        let projectedOrigin = sceneView.projectPoint(SCNVector3Zero)
        
        let vpWithZ = SCNVector3(x: Float(point.x), y: Float(point.y), z: projectedOrigin.z)
        let worldPoint = sceneView.unprojectPoint(vpWithZ)

        return CGPoint(x: CGFloat(worldPoint.x), y: CGFloat(worldPoint.y))
    }

    private func rotateGraph() {

        var rotX = rotAngleX
        var rotY = rotAngleY
        if animated {
            rotX = 0.0
            rotY = 0.0
        }
        
        var rotAnim = CABasicAnimation(keyPath: "transform");
        rotAnim.duration = 0.5;
        rotAnim.toValue = NSValue(SCNMatrix4: SCNMatrix4Mult(SCNMatrix4MakeRotation(Float(degreeToRadian(rotX)), 1, 0, 0), SCNMatrix4MakeRotation(Float(degreeToRadian(rotY)), 0, 1, 0)))
        rotAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotAnim.delegate = self
        rotAnim.removedOnCompletion = false
        rotAnim.fillMode = kCAFillModeForwards
        mainNode.addAnimation(rotAnim, forKey: "transform")
    }
    
    private func degreeToRadian(angle: CGFloat) -> CGFloat {
        
        return angle * CGFloat(M_PI) / 180.0
    }
    
    private func getNewValue(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {

        let oldRange = max - min
        if oldRange == 0 {
            return MINRANGE
        } else {
            let newRange = (MAXRANGE*0.9) - MINRANGE
            return (((value - min) * newRange) / oldRange) + MINRANGE
        }
    }

}
