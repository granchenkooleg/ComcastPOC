//
//  NetworkExtension.swift
//  Comcast POC
//
//  Created by Oleg Granchenko on 07.05.2025.
//

import NetworkExtension

final class PacketTunnelProvider: NEPacketTunnelProvider {

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "10.0.0.1")
        settings.ipv4Settings = NEIPv4Settings(addresses: ["10.0.0.2"], subnetMasks: ["255.255.255.0"])
        settings.dnsSettings = NEDNSSettings(servers: ["8.8.8.8"])

        setTunnelNetworkSettings(settings) { error in
            guard error == nil else {
                completionHandler(error)
                return
            }
            self.startReadingPackets()
            completionHandler(nil)
        }
    }

    private func startReadingPackets() {
        packetFlow.readPackets { [weak self] packets, protocols in
            for packet in packets {
                self?.forwardPacketOverCellular(packet)
            }
            self?.startReadingPackets()
        }
    }

    private func forwardPacketOverCellular(_ packet: Data) {
        let parameters = NWParameters.tcp
        parameters.requiredInterfaceType = .cellular

        let connection = NWConnection(host: "example.com", port: 80, using: parameters)
        connection.start(queue: .global())

        connection.send(content: packet, completion: .contentProcessed { _ in
            connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { response, _, _, _ in
                if let response = response {
                    self.packetFlow.writePackets([response], withProtocols: [AF_INET as NSNumber])
                }
                connection.cancel()
            }
        })
    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

