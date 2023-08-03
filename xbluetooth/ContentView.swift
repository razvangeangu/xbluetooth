//
//  ContentView.swift
//  xbluetooth
//
//  Created by Razvan-Gabriel Geangu on 03/08/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        ScrollView {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(bluetoothManager.pairedDevices, id: \.addressString) { device in
                        BluetoothMenuItem(
                            title: "\(device.name ?? "Unknown Device")",
                            subtitle: device.isConnected() ? "Connected - \(device.addressString ?? "Unknown MAC Address")" : "Disconnected",
                            buttonTitle: "Unpair"
                        ) {
                            bluetoothManager.unpair(device)
                        }
                        
                        if bluetoothManager.pairedDevices.last != device {
                            Divider().background(CARD_COLOR)
                        }
                    }
                    
                    if bluetoothManager.pairedDevices.count == 0 {
                        HStack {
                            Text("No Paired Devices")
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(CARD_COLOR)
                .border(BORDER_COLOR)
                .cornerRadius(CORNER_RADIUS)
                .padding()
            } header: {
                HStack {
                    Text("My Devices")
                        .font(.headline)
                    Spacer()
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
            }
            
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(bluetoothManager.devices, id: \.addressString) { device in
                        BluetoothMenuItem(
                            title: "\(device.name ?? "Unknown Device")",
                            subtitle: device.addressString,
                            buttonTitle: "Pair"
                        ) {
                            if device.isPaired() {
                                bluetoothManager.unpair(device)
                            } else {
                                bluetoothManager.pair(device)
                            }
                        }
                        
                        if bluetoothManager.devices.last != device {
                            Divider().background(CARD_COLOR)
                        }
                    }
                    
                    if bluetoothManager.devices.count == 0 {
                        HStack {
                            Text("Searching...")
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(CARD_COLOR)
                .border(BORDER_COLOR)
                .cornerRadius(CORNER_RADIUS)
                .padding()
            } header: {
                HStack {
                    Text("Nearby Devices")
                        .font(.headline)
                    if bluetoothManager.isInquiring {
                        ProgressView()
                            .controlSize(.small)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            }
        }
    }
}

#Preview {
    ContentView()
}
