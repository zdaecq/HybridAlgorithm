//
//  SupportFile.swift
//  HybridAlgorithm
//
//  Created by zdaecqze zdaecq on 21.05.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Print functions
func printTimeElapsedWhenRunningCode(title title:String, operation:()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) s")
}

func printArray(array: [[Float]]) {
    let arrayCount = array.count - 1
    var str = ""
    var numberString = ""
    
    for i in 0...arrayCount {
        str = ""
        
        for j in 0...arrayCount {
            
            numberString = String(format: "%.0f", array[i][j])
            //if numberString == "0.000" {
            //numberString = "000.000"
            //}
            str = str + numberString + " "
        }
        
        print (str)
    }
}


// MARK: - Draw extentions
extension CGRect {
    init (width: CGFloat, inCenterOfPoint point: CGPoint) {
        self.origin = CGPoint(x: point.x - width/2, y: point.y - width/2)
        self.size = CGSize(width: width, height: width)
    }
}


extension CAShapeLayer {
    convenience init(path: UIBezierPath, lineWidth: CGFloat) {
        self.init()
        self.path = path.CGPath
        strokeColor = UIColor.redColor().CGColor
        self.lineWidth = lineWidth
    }
}

extension UIView {
    func drawPoint(point: CGPoint, withRadius radius: CGFloat) {
        let square = CGRect(width: radius, inCenterOfPoint: point)
        let path = UIBezierPath(ovalInRect: square)
        let shapeLayer = CAShapeLayer(path: path, lineWidth: radius)
        layer.addSublayer(shapeLayer)
    }
}




// MARK: - Shuffle extensions
extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}