//
//  QRScannerViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let finishScanning = "FinishScanning"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var centerView: UIView!

    // MARK: -

    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    private var shouldConfigureLayer = true

    // MARK: - Instance Methods

    @IBAction private func onCloseButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.dismiss(animated: true)
    }

    // MARK: -

    private func configureVideoCapture() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            return
        }

        guard self.captureSession.canAddInput(videoInput) else {
            Log.w("Your device does not support scanning a code from an item. Please use a device with a camera.")
            return
        }

        self.captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()

        guard self.captureSession.canAddOutput(metadataOutput) else {
            Log.w("Can not add metadata output")
            return
        }

        self.captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.qr]
    }

    private func configureVideoPreviewLayer() {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)

        videoPreviewLayer.frame = self.view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill

        self.view.layer.insertSublayer(videoPreviewLayer, at: 0)

        self.videoPreviewLayer = videoPreviewLayer
    }

    private func configureCaptureSession() {
        self.captureSession.startRunning()
    }

    private func configureLayer() {
        let path = UIBezierPath(roundedRect: self.view.bounds, cornerRadius: 0)
        let centerPath = UIBezierPath(roundedRect: self.centerView.frame, cornerRadius: 11)

        path.append(centerPath)
        path.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()

        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = Colors.scannerBackground.cgColor
        fillLayer.opacity = 0.65

        self.view.layer.insertSublayer(fillLayer, above: self.videoPreviewLayer)

        self.shouldConfigureLayer = false
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureVideoCapture()
        self.configureVideoPreviewLayer()
        self.configureCaptureSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !self.captureSession.isRunning {
            self.captureSession.startRunning()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.shouldConfigureLayer {
            self.configureLayer()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.captureSession.isRunning {
            self.captureSession.stopRunning()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let dictionaryReceiver: DictionaryReceiver?

        if let navigationController = segue.destination as? UINavigationController {
            dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
        } else {
            dictionaryReceiver = segue.destination as? DictionaryReceiver
        }

        switch segue.identifier {
        case Segues.finishScanning:
            guard let stringValue = sender as? String else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["QRCodeMetadata": stringValue])
            }

        default:
            return
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }

            guard let stringValue = readableObject.stringValue else {
                return
            }

            self.captureSession.stopRunning()

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

            self.performSegue(withIdentifier: Segues.finishScanning, sender: stringValue)
        }
    }
}
