//
//  ViewController.swift
//  ARD Blue Test
//
//  Created by reinert wasserman on 1/7/2023.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController {
    var receivedData: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedData(_:)), name: Notification.Name("receivedData"), object: nil)
    }

    @objc func handleReceivedData(_ notification: Notification) {
        if let data = notification.object as? String {
            receivedData = data
            print(data)
        }
    }
    
    @IBAction func onSlider(_ sender: UISlider) {
        let value = Int(sender.value)
            print("Slider value: \(value)")

            // Convert integer to data
            let data = Data("\(value)".utf8)

            if let connectedCharacteristic = BrevilleManager.shared.connectedCharacteristic {
                BrevilleManager.shared.selectedPeripheral?.writeValue(data, for: connectedCharacteristic, type: .withResponse)
            }
    }
    
    @IBAction func onDisconnect(_ sender: UIButton) {
        BrevilleManager.shared.disconnectPeripheral()
    }
}
