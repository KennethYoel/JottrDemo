//
//  NetworkMonitor.swift
//  HandlingLoadingState
//
//  Created by Kenneth Gutierrez on 10/5/22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Network

class NetworkMonitor: ObservableObject {
    /*
     two properties, of which one is to store the internal NWPathMonitor watching for changes, and the other to store
     a DispatchQueue where the monitoring work will take place.
     */
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    /*
     we have four properties that describe the network availability: whether it’s active (do we have access to the network?),
     whether it’s expensive (cellular or WiFi using a cellular hotspot), whether it’s constrained (restricted by low data
     mode), and the exact connection type we have (WiFi, cellular, etc).
     */
    var isActive = false
    var isExpensive = false
    var isConstrained = false
    var connectionType = NWInterface.InterfaceType.other
    
    /*
     tells the internal NWPathMonitor what it should do when changes come in, and tells it start monitoring on our private
     queue:
     */
    init() {
        monitor.pathUpdateHandler = { path in
            // store our latest networking values in our property, then notify anyone who is watching for updates.
            self.isActive = path.status == .satisfied
            self.isExpensive = path.isExpensive
            self.isConstrained = path.isConstrained

            let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
            self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other

            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }

        monitor.start(queue: queue)
    }
}
