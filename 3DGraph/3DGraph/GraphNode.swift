//
//  GraphNode.swift
//  3DGraph
//
//  Created by Greg Lecki on 25/08/2015.
//  Copyright (c) 2015 Greg Lecki. All rights reserved.
//

import UIKit
import SceneKit


class GraphNode: SCNNode {
   
    private var barNodes: [BarNode]
    private var columns: Int
    var horizontalSpace: Float = 2
    var verticalSpace: Float = 2
    var xAxisLabels: [NSAttributedString]?
    var yAxisLabels: [NSAttributedString]?
    var xLabelsOnTop = true
    var yLabelsOnLeft = true
    
    init(barNodes: [BarNode], columns: Int = 3) {
        
        self.barNodes = barNodes
        self.columns = columns
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func reDrawGraph() {
        prepareGraph()
    }
    
    private var startPositionX: Float = 0
    private var startPositionY: Float = 0
    
    private func prepareGraph() {
        
        let mainNode = SCNNode()
        
        var maxColsOrBars = columns > barNodes.count ? barNodes.count : columns
        var totalRowLength: Float = Float(barNodes[0..<maxColsOrBars].reduce(0) { $0 + $1.width })
        totalRowLength += (horizontalSpace * Float(maxColsOrBars - 1))

        var maxLabelWidth: Float = 0
        if let xlabels = xAxisLabels {
            for lab in xlabels {
                maxLabelWidth = (Float(lab.size().width) > maxLabelWidth) ? Float(lab.size().width) : maxLabelWidth
            }
            totalRowLength += horizontalSpace
        }
        totalRowLength += maxLabelWidth
        
        var totalColumnLength: Float = 0.0
        for (index, element) in enumerate(barNodes) {
            if index % columns == 0 {
                totalColumnLength += Float(element.height)
            }
        }
        var maxLabelHeight: Float = 0
        if let ylabels = yAxisLabels {
            for lab in ylabels {
                maxLabelHeight = (Float(lab.size().height) > maxLabelHeight) ? Float(lab.size().height) : maxLabelHeight
                totalColumnLength += verticalSpace
            }
        }
        totalColumnLength + maxLabelHeight

        var rowsCount = Int(ceilf(Float(barNodes.count)/Float(columns)))
        totalColumnLength += verticalSpace * Float(rowsCount-1)
        
        if xLabelsOnTop {
            startPositionY = totalColumnLength/2 - (maxLabelHeight + verticalSpace)
        } else {
            startPositionY = totalColumnLength/2
        }
        
        if yLabelsOnLeft {
            startPositionX = -totalRowLength/2 + maxLabelWidth/2 + horizontalSpace
        } else {
            startPositionX = -totalRowLength/2 + (2 * horizontalSpace)
        }

        var positionX: Float = startPositionX
        var positionY: Float = startPositionY
        
        for (index, bar) in enumerate(barNodes) {
            
            bar.index = index
            
            if index % columns == 0 {
                var aboveHeight: Float = 0.0
                if index - columns >= 0 {
                    aboveHeight = Float(barNodes[index-columns].height)
                }
                
                positionY -= aboveHeight/2 + Float(verticalSpace) + Float(bar.height/2)
                positionX = startPositionX
            }
            
            positionX += Float(bar.width/2)
            
            bar.position = SCNVector3Make(positionX, positionY, 0)
            positionX += Float(horizontalSpace) + Float(bar.width/2)
            
            mainNode.addChildNode(bar)
        }
        
        addChildNode(mainNode)
        
        addLabel()
    }

    private func addLabel() {

        if let xAxisLab = xAxisLabels {
            var maxCol = columns <= barNodes.count ? columns : barNodes.count
            for index in 0..<maxCol {
                var xPos: Float = 0
                var yPos: Float = 0
                if index < xAxisLab.count {
                    let textLabel = xAxisLab[index]
                    if xLabelsOnTop {
                        
                        if index < barNodes.count {
                            
                            let bar = barNodes[index]
                            xPos = bar.position.x
                            yPos = startPositionY
                        }
                        
                    } else {
                        if let bar = barNodes.last {
                            yPos = bar.position.y - Float(bar.height/2) - verticalSpace - Float(textLabel.size().height)
                        }
                        if index < barNodes.count {
                            
                            let bar = barNodes[index]
                            xPos = bar.position.x                            
                        }
                    }
                    
                    let xLabelNode = LabelNode(text:textLabel)
                    
                    if let n = xLabelNode.getLabel() {
                        n.position = SCNVector3(x: xPos - Float(textLabel.size().width/2), y: yPos, z: 0)
                        addChildNode(n)
                    }
                }
            }
        }
        
        
        if let yAxisLab = yAxisLabels {
            var rowsCount = Int(ceilf(Float(barNodes.count)/Float(columns)))
            for index in 0..<rowsCount {
                var xPos: Float = 0
                var yPos: Float = 0
                if index < yAxisLab.count {
                    let textLabel = yAxisLab[index]
                    
                    if yLabelsOnLeft {
                        var idx = index * columns
                        if idx < barNodes.count {
                            
                            let bar = barNodes[idx]
                            xPos = startPositionX - horizontalSpace - Float(textLabel.size().width)
                            yPos = bar.position.y
                        }
                        
                    } else {
                        if barNodes.count > columns-1 {
                            let tempBar = barNodes[columns-1]
                            xPos = tempBar.position.x + Float(tempBar.width/2) + horizontalSpace
                            
                            var idx = index * columns
                            if idx < barNodes.count {
                                
                                let bar = barNodes[idx]
                                yPos = bar.position.y
                            }
                        }
                    }
                    
                    let yLabelNode = LabelNode(text:textLabel)
                    
                    if let n = yLabelNode.getLabel() {
                        n.position = SCNVector3(x: xPos, y: yPos, z: 0)
                        addChildNode(n)
                    }
                }
            }
        }
    }
}
