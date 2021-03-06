//
//  CodeReaderVC.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class CodeReaderVC: UIViewController {
    
    let session = AVCaptureSession()
    var video = AVCaptureVideoPreviewLayer()
    
    let vm = MachineDataViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.startRunning()
        self.vm.fetchCoreData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.stopRunning()
    }
    
    func setup() {
        
        //Define Capture Device
        let cameraPosition: AVCaptureDevice.Position = .back
        guard let captureDevice = self.captureDevice(forPosition: cameraPosition) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch let error {
            print("error: ", error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        video.videoGravity = .resizeAspectFill
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 11.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
            return discoverySession.devices.first { $0.position == position}
        }
        return nil
    }
}

@available(iOS 13.0, *)
extension CodeReaderVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != [] && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == .qr {
                    let data = self.vm.machineData
                    let searchValue = object.stringValue!
                    var currentIndex = 0
                    
                    for index in 0...data.count {
                        let selectedData = data[index]
                        if selectedData.machineQrCode.toString() == searchValue {
                            let vc = MachineDataFormVC(vm: self.vm, data: selectedData, isEdit: true)
                            
                            vc.idString = selectedData.machineID ?? ""
                            vc.nameString = selectedData.machineName ?? ""
                            vc.typeString = selectedData.machineType ??  ""
                            vc.qrString = String(selectedData.machineQrCode)
                            vc.dateString = selectedData.maintenanceDate?.toString() ?? ""
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            break
                        }
                        break
                        currentIndex += 1
                    }
                }
            }
        }
    }
}
