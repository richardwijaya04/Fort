import SwiftUI
import AVFoundation

struct OCRCameraView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    var viewModel: OCRCameraViewModel
    
    init(viewModel: OCRCameraViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupCamera() {
        viewModel.session.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              viewModel.session.canAddInput(input) else {
            print("Camera setup failed.")
            return
        }

        viewModel.session.beginConfiguration()
        viewModel.session.addInput(input)

        if viewModel.session.canAddOutput(viewModel.output) {
            viewModel.session.addOutput(viewModel.output)
        } else {
            print("Failed to add photo output")
        }

        viewModel.session.commitConfiguration()
        viewModel.startCamera()
    }


    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = viewModel.session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill

        setupCamera()

        return view
    }


    func updateUIView(_ uiView: VideoPreviewView, context: Context) {}

    func dismantleUIView(_ uiView: VideoPreviewView, coordinator: Coordinator) {
        viewModel.stopCamera()
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}
