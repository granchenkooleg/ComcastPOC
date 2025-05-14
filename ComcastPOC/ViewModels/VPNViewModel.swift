//
//  VPNViewModel.swift
//  Comcast POC
//
//  Created by Oleg Granchenko on 07.05.2025.
//

import SwiftUI

final class VPNViewModel: ObservableObject {
    @Published var isRunning = false
    @Published var status: String = "Not connected"

    private let tunnelManager = TunnelManager()

    func toggleTunnel() {
        if isRunning {
            tunnelManager.stopTunnel {
                DispatchQueue.main.async {
                    self.isRunning = false
                    self.status = "Stopped"
                }
            }
        } else {
            tunnelManager.startTunnel { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.status = "Error: \(error.localizedDescription)"
                    } else {
                        self.isRunning = true
                        self.status = "Running"
                    }
                }
            }
        }
    }
}
