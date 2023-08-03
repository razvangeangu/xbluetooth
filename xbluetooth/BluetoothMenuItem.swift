//
//  BluetoothMenuItem.swift
//  xbluetooth
//
//  Created by Razvan-Gabriel Geangu on 03/08/2023.
//

import SwiftUI

struct BluetoothMenuItem: View {
    var imageName: String?
    var title: String
    var subtitle: String?
    var buttonTitle: String?
    var action: (() -> Void)?
    
    @State private var isHovering: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            if let imageName = imageName {
                Image(systemName: imageName)
                    .frame(minWidth: 20.0, minHeight: 20.0)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            Spacer()
            
            if let action = action, let buttonTitle = buttonTitle, isHovering {
                Button(buttonTitle, action: action)
            }
        }
        .onHover { isHovering in
            self.isHovering = isHovering
        }
        .frame(minHeight: 20.0)
    }
}
