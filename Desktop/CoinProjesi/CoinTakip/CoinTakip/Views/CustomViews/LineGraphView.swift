//
//  LineGraphView.swift
//  CoinTakip
//
//  Created by Yunus Emre ÖZŞAHİN on 6.05.2024.
//

import UIKit

class LineGraphView: UIView {
    var points: [CGPoint] = []
    var values: [Double] = []
    private var valueLabel = UILabel()

    func setGraphData(values: [Double]) {
        self.values = values
        let maxValue = values.max() ?? 1
        let minValue = values.min() ?? 0
        let graphWidth = bounds.width - 40
        let graphHeight = bounds.height - 40
        let stepX = graphWidth / CGFloat(values.count - 1)

        points = values.enumerated().map { index, value in
            let xPosition = CGFloat(index) * stepX + 20
            let yPosition = graphHeight * (1 - CGFloat((value - minValue) / (maxValue - minValue))) + 20
            return CGPoint(x: xPosition, y: yPosition)
        }
        print("total point: \(points.count)")
        setupValueLabel()
        setNeedsDisplay()
    }

    private func setupValueLabel() {
        valueLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 20)
        valueLabel.backgroundColor = .white
        valueLabel.textColor = .black
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.isHidden = true
        addSubview(valueLabel)
    }
    private func drawWickLine(context: CGContext, point: CGPoint) {
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(2)
        context.beginPath()
        context.move(to: CGPoint(x: point.x, y: point.y))
        context.addLine(to: CGPoint(x: point.x, y: bounds.height - 20))
        context.strokePath()
    }

    override func draw(_ rect: CGRect) {
            super.draw(rect)
            guard let context = UIGraphicsGetCurrentContext(), !points.isEmpty else { return }
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2)
            context.setLineJoin(.round)

            let path = UIBezierPath()
            path.move(to: points.first!)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
            context.addPath(path.cgPath)
            context.strokePath()
            drawFillUnderLineGraph(context: context)
            drawPoints(context: context)
            drawHours()
            drawGrid(context: context)
        }


    private func drawGrid(context: CGContext) {
        let lineInterval = bounds.height / 10
        let stepX = (bounds.width - 40) / CGFloat(points.count - 1)

        context.setStrokeColor(UIColor.gray.withAlphaComponent(0.2).cgColor)
        context.setLineWidth(1)
        context.setLineDash(phase: 0, lengths: [5, 5])

        for i in 0..<points.count {
            let x = CGFloat(i) * stepX + 20
            context.move(to: CGPoint(x: x, y: 20))
            context.addLine(to: CGPoint(x: x, y: bounds.height - 20))
        }
        for i in 0..<10 {
            let y = lineInterval * CGFloat(i) + 20
            context.move(to: CGPoint(x: 20, y: y))
            context.addLine(to: CGPoint(x: bounds.width - 20, y: y))
        }

        context.strokePath()
    }
    private func drawFillUnderLineGraph(context: CGContext) {
            for i in 0..<points.count - 1 {
                let startPoint = points[i]
                let endPoint = points[i + 1]

                let path = UIBezierPath()
                path.move(to: startPoint)
                path.addLine(to: endPoint)
                path.addLine(to: CGPoint(x: endPoint.x, y: bounds.height - 20))
                path.addLine(to: CGPoint(x: startPoint.x, y: bounds.height - 20))
                path.close()

                let color = values[i + 1] > values[i] ? UIColor.green2.withAlphaComponent(0.8) : UIColor.red.withAlphaComponent(0.8)
                context.setFillColor(color.cgColor)
                context.addPath(path.cgPath)
                context.fillPath()
                drawWickLine(context: context, point: startPoint)
                        if i == points.count - 2 {
                            drawWickLine(context: context, point: endPoint)
                        }
            }
        }
    private func drawGraph(context: CGContext) {
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(2)
        context.setLineJoin(.round)

        context.beginPath()
        context.move(to: points.first!)
        for point in points.dropFirst() {
            context.addLine(to: point)
        }
        context.strokePath()
    }

    private func drawPoints(context: CGContext) {
        context.setFillColor(UIColor.black.cgColor)
        for point in points {
            context.fillEllipse(in: CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))
        }
    }

    private func drawHours() {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.black
        ]

        for (index, point) in points.enumerated() {
            let hourString = "\(index + 1)"
            let string = NSAttributedString(string: hourString, attributes: textAttributes)
            string.draw(at: CGPoint(x: point.x - 10, y: bounds.height - 15))
        }
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        for (index, point) in points.enumerated() {
            if abs(touchPoint.x - point.x) < 10 && abs(touchPoint.y - point.y) < 10 {
                valueLabel.text = "\(String(values[index]).asDollarCurrency)"
                valueLabel.center = CGPoint(x: point.x, y: point.y - 20)
                valueLabel.isHidden = false
                valueLabel.numberOfLines = 0
                break
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        valueLabel.isHidden = true
    }
}


