//
//  ARViewContainer.swift
//  PassiveLivenessApp
//
//  Created by Lin Dan Christiano on 16/07/25.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: LivenessViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            DispatchQueue.main.async {
                viewModel.statusMessage = "Perangkat tidak mendukung pelacakan wajah."
            }
            return arView
        }

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration)
        
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var viewModel: LivenessViewModel
        weak var arView: ARView?

        init(viewModel: LivenessViewModel) {
            self.viewModel = viewModel
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            guard let arView = arView else { return }
            
            let faceAnchor = anchors.compactMap { $0 as? ARFaceAnchor }.first
            
            var faceScreenPoint: CGPoint?
            if let faceAnchor = faceAnchor {
                let centerTransform = faceAnchor.transform
                
                let worldPosition4 = centerTransform.columns.3
                let worldPosition3 = SIMD3<Float>(worldPosition4.x, worldPosition4.y, worldPosition4.z)
                
                faceScreenPoint = arView.project(worldPosition3)
            }
            
            DispatchQueue.main.async {
                self.viewModel.process(anchor: faceAnchor, faceScreenPoint: faceScreenPoint)
            }
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            DispatchQueue.main.async {
                self.viewModel.statusMessage = "Sesi AR gagal: \(error.localizedDescription)"
            }
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            DispatchQueue.main.async {
                self.viewModel.statusMessage = "Sesi AR terganggu"
            }
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            DispatchQueue.main.async {
                self.viewModel.statusMessage = "Posisikan wajah Anda di dalam bingkai"
            }
        }
    }
}
