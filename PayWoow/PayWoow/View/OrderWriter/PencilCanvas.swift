//
//  PencilCanvas.swift
//  PayWoowNew
//
//  Created by İsa Yılmaz on 12/9/21.
//

import SwiftUI
import PencilKit


struct PencilCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.frame = CGRect(x: 0, y: 0, width: 400, height: 80)
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .white
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
    }
}
