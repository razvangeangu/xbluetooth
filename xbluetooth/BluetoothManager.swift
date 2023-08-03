//
//  BluetoothManager.swift
//  xbluetooth
//
//  Created by Razvan-Gabriel Geangu on 03/08/2023.
//

import IOBluetooth

class BluetoothManager: NSObject, ObservableObject, IOBluetoothDeviceInquiryDelegate, IOBluetoothDevicePairDelegate {
    private var deviceInquiry: IOBluetoothDeviceInquiry!
    @Published var devices: [IOBluetoothDevice] = []
    @Published var pairedDevices: [IOBluetoothDevice] = []
    @Published var isInquiring = false
    
    override init() {
        super.init()
        self.deviceInquiry = IOBluetoothDeviceInquiry(delegate: self)
        self.startInquiry()
        self.loadPairedDevices()
    }
    
    func startInquiry() {
        deviceInquiry.start()
        self.isInquiring = true
    }
    
    func stopInquiry() {
        deviceInquiry.stop()
        self.isInquiring = false
    }
    
    func loadPairedDevices() {
        if let pairedDevices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] {
            self.pairedDevices = pairedDevices
        }
    }
    
    func pair(_ device: IOBluetoothDevice) {
        let devicePair = IOBluetoothDevicePair(device: device)
        devicePair?.delegate = self
        devicePair?.start()
        self.devices = self.devices.filter { $0 != device }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loadPairedDevices()
        }
    }
    
    func unpair(_ device: IOBluetoothDevice) {
        if device.responds(to: "remove") {
            device.performSelector(onMainThread: "remove", with: nil, waitUntilDone: true)
            self.loadPairedDevices()
        }
    }
    
    func deviceInquiryDeviceFound(_ sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
        if !devices.contains(device) {
            devices.append(device)
        }
    }
    
    func deviceInquiryComplete(_ sender: IOBluetoothDeviceInquiry!, error: IOReturn, aborted: Bool) {
        debugPrint("Device inquiry complete.")
    }
}
