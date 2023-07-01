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


    }

    
    @IBAction func onSlider(_ sender: UISlider) {
        let value = Float(sender.value)
            print("Slider value: \(value)")
        BrevilleManager.shared.writeServoPosition(value)
    }
    
    @IBAction func onPowerButtonDown(_ sender: UIButton) {
        BrevilleManager.shared.writePowerButton(true)
    }

    @IBAction func onPowerButtonUp(_ sender: UIButton) {
        BrevilleManager.shared.writePowerButton(false)
    }

    
    @IBAction func onBrewDwon(_ sender: UIButton) {
        BrevilleManager.shared.writeBrewButton(true)

    }
    
    @IBAction func onBrewUp(_ sender: UIButton) {
        BrevilleManager.shared.writeBrewButton(false)

    }
    
    @IBAction func onDisconnect(_ sender: UIButton) {
        BrevilleManager.shared.disconnectPeripheral()
    }
}
