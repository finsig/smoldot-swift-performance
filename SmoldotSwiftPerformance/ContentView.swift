//
//  ContentView.swift
//  SmoldotSwiftPerformance
//
//  Created by Steven Boynes on 6/26/24.
//

import SwiftUI
import SmoldotSwift

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "chart.dots.scatter")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("View XCode Memory Report...")
                .padding()
        }
        .padding()
        .task {
            //baseline()
            //addSingleChain()
            await addChainRemoveChain()
            //await subscription()
        }
    }
}


fileprivate extension ContentView {
    
    func baseline() {
        // do nothing
    }
    
    func addSingleChain() {
        var chain = Chain.polkadot
        do {
            try Client.shared.add(chain: &chain)
        }
        catch {
            print(error)
        }
    }
    
    func addChainRemoveChain() async {
        var chain = Chain.polkadot
        while(true) {
            do {
                try Client.shared.add(chain: &chain)
                try await Task.sleep(nanoseconds: 1_000_000_000 * 30) // sleep
                try Client.shared.remove(chain: &chain)
                try await Task.sleep(nanoseconds: 1_000_000_000 * 30) // sleep
            }
            catch {
                print(error)
                break
            }
        }
    }
    
    func subscription() async {
        var chain = Chain.polkadot
        do {
            try Client.shared.add(chain: &chain)
            
            let string = "{\"id\":1,\"jsonrpc\":\"2.0\",\"method\":\"chain_subscribeNewHeads\",\"params\":[]}"
            let request = try JSONRPC2Request(string: string)
            try Client.shared.send(request: request, to: chain)
            
            for try await response in Client.shared.responses(from: chain) {
                print(response)
            }
        }
        catch {
            print(error)
        }
    }
}
