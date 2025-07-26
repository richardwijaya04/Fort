//
//  LivenessView.swift
//  Fort
//
//  Created by Lin Dan Christiano on 21/07/25.
//

import RealityKit
import SwiftUI
import Vision

struct LivenessView: View {
    @StateObject private var viewModel = LivenessViewModel()
    @State private var frameRect: CGRect = .zero
    @State private var isLayoutInitialized = false
    @State private var isRunning = false
    @State private var hasNavigated = false
    
    let onSuccess: () -> Void
    let onFailure: () -> Void

    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(isRunning ? "" : "Posisikan Wajah Anda")
                        .font(.system(size: 24, weight: .semibold,))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .padding(.leading, 40)
                        
                    Text(statusText)
                        .font(.system(size: isRunning ? 24 : 16, weight: isRunning ? .semibold : .regular))
                        .frame(maxWidth: viewModel.isFaceDetected ? 400 : .infinity, minHeight: 50, alignment: isRunning ? .center : .leading)
                        .foregroundColor(.black)
                        .padding(.trailing, 15)
                        .padding(.leading, 40)
                        
                        .animation(.none, value: viewModel.statusMessage)
                }
                GeometryReader { geometry in
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(
                                width: geometry.size.width * 0.7,
                                height: geometry.size.width * 0.7
                            )
                            .overlay(
                                Circle()
                                    .stroke(frameColor, lineWidth: 3)
                                    .animation(
                                        .easeInOut(duration: 0.3),
                                        value: viewModel.isFaceDetected
                                    )
                            )
                            .shadow(
                                color: .black.opacity(0.1),
                                radius: 10,
                                x: 0,
                                y: 5
                            )

                        if isRunning {
                            ARViewContainer(viewModel: viewModel)
                                .clipShape(Circle())
                                .frame(
                                    width: geometry.size.width * 0.7 - 6,
                                    height: geometry.size.width * 0.7 - 6
                                )
                        } else {
                            CameraPreview(viewModel: viewModel)
                                .clipShape(Circle())
                                .frame(
                                    width: geometry.size.width * 0.7 - 6,
                                    height: geometry.size.width * 0.7 - 6
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
                    .onAppear {
                        setupFrameRect(geometry: geometry)
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.4)

                Spacer()
                
                Text(
                    !isRunning
                        ? "Pastikan proses ini dilakukan oleh pemilik akun secara langsung"
                        : ""
                )
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray)
                Button {
                    startVerification()
                } label: {
                    Text("Mulai Verifikasi")
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .bold()
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(
                                !canStartVerification
                                    ? Color.gray : Color("Primary")
                            )
                        )
                }
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(
                        buttonBackgroundColor
                    )
                )
                .opacity(buttonOpacity)
                .disabled(!canStartVerification)
                .animation(
                    .easeInOut(duration: 0.3),
                    value: viewModel.isFaceDetected
                )
                .padding(.horizontal, 32)
            }

            // Success overlay
//            if viewModel.isSuccess {
//                successOverlay
//                    .ignoresSafeArea()
//            }
        }
        .onAppear {
            viewModel.startFaceDetection()
            hasNavigated = false
        }
        .onDisappear {
            viewModel.stopSession()
        }
        .onChange(of: viewModel.isSuccess) { _, isSuccess in
            if isSuccess {
                onSuccess()
            }
        }
        .onChange(of: viewModel.isFailure) { _, isFailure in
            if isFailure {
                onFailure()
            }
        }
    }
    
    // MARK: - Computed Properties
    private var statusText: String {
        if isRunning {
            return viewModel.statusMessage
        } else if viewModel.isFaceDetected {
            return """
            Wajah terdeteksi! 
            Tekan tombol untuk memulai
            """
        } else {
            return "Pastikan berada di dalam lingkaran \n dan terlihat jelas"
        }
    }

    private var frameColor: Color {
        if isRunning {
            return viewModel.isFaceInFrame ? Color("Primary") : .orange
        } else {
            return viewModel.isFaceDetected ? Color("Primary") : .gray.opacity(0.5)
        }
    }

    private var canStartVerification: Bool {
        return viewModel.isFaceDetected && !isRunning
    }
    
    private var buttonBackgroundColor: Color {
        return canStartVerification ? Color("Primary") : .gray
    }

    private var buttonOpacity: Double {
        return canStartVerification ? 1.0 : 0.5
    }

    private var successOverlay: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)

                Text("Verifikasi Berhasil!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 300, height: 300)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color("Primary").opacity(0.8)))
        .transition(.opacity.animation(.easeIn(duration: 0.5)))
    }

    // MARK: - Helper Methods
    private func setupFrameRect(geometry: GeometryProxy) {
        if !isLayoutInitialized {
            let frameWidth = geometry.size.width * 0.7
            let frameHeight = frameWidth
            let originX = (geometry.size.width - frameWidth) / 2
            let originY = (geometry.size.height - frameHeight) / 2
            self.frameRect = CGRect(
                x: originX,
                y: originY,
                width: frameWidth,
                height: frameHeight
            )
            viewModel.setFrame(rect: self.frameRect)
            isLayoutInitialized = true
        }
    }

    private func startVerification() {
        guard canStartVerification else { return }
        isRunning = true
        viewModel.startLivenessDetection()
    }
}
