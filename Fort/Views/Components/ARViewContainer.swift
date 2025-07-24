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
        
        // Berikan instance arView ke Coordinator
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Tidak perlu implementasi khusus
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
            
            // Proyeksikan titik 3D wajah ke titik 2D di layar
            var faceScreenPoint: CGPoint?
            if let faceAnchor = faceAnchor {
                // Ambil titik tengah wajah di dunia 3D
                let centerTransform = faceAnchor.transform
                
                // Konversi SIMD4 ke SIMD3 sebelum memproyeksikan
                let worldPosition4 = centerTransform.columns.3
                let worldPosition3 = SIMD3<Float>(worldPosition4.x, worldPosition4.y, worldPosition4.z)
                
                // Proyeksikan ke layar 2D
                faceScreenPoint = arView.project(worldPosition3)
            }
            
            // Kirim anchor dan titik 2D ke ViewModel
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
