//
//  ContentView.swift
//  Comcast POC
//
//  Created by Oleg Granchenko on 07.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VPNViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("LTE Failover VPN")
                .font(.title)
                .padding(.top)

            Text(viewModel.status)
                .foregroundColor(.gray)

            Button(viewModel.isRunning ? "Stop Tunnel" : "Start Tunnel") {
                viewModel.toggleTunnel()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
