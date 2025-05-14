//
//  TunnelManager.swift
//  Comcast POC
//
//  Created by Oleg Granchenko on 07.05.2025.
//

import SwiftUI

final class TunnelManager {
    private var provider: PacketTunnelProvider?

    func startTunnel(completion: @escaping (Error?) -> Void) {
        provider = PacketTunnelProvider()
        provider?.startTunnel(options: nil, completionHandler: completion)
    }

    func stopTunnel(completion: @escaping () -> Void) {
        provider?.stopTunnel(with: .userInitiated, completionHandler: completion)
        provider = nil
    }
}
