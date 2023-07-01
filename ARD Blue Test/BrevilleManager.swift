import CoreBluetooth

class BrevilleManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BrevilleManager()

    var manager: CBCentralManager!
    var peripherals: [UUID: CBPeripheral] = [:]
    var selectedPeripheral: CBPeripheral?
    var connectedService: CBService?
    var connectedCharacteristic: CBCharacteristic?
    var timer: Timer?

    private override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScan()
        } else {
            print("Bluetooth not available.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals[peripheral.identifier] = peripheral
        NotificationCenter.default.post(name: Notification.Name("reloadTableView"), object: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func startScan() {
        peripherals.removeAll()
        manager.scanForPeripherals(withServices: nil, options: nil)
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.manager.stopScan()
        })
    }

    func connectToPeripheral(_ peripheral: CBPeripheral) {
        selectedPeripheral = peripheral
        manager.connect(selectedPeripheral!, options: nil)
    }

    func disconnectPeripheral() {
        if let peripheral = selectedPeripheral {
            manager.cancelPeripheralConnection(peripheral)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        print("Discovered services for peripheral \(peripheral.identifier): \(services.map { $0.uuid })")

        for service in services {
            if service.uuid.uuidString == "19B10000-E8F2-537E-4F6C-D104768A1214" {
                connectedService = service
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }


    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        print("Discovered characteristics for service \(service.uuid): \(characteristics.map { $0.uuid })")

        for characteristic in characteristics {
            if characteristic.uuid.uuidString == "19B10001-E8F2-537E-4F6C-D104768A1214" {
                connectedCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Failed to read characteristic value: \(error)")
            return
        }

        if let value = characteristic.value, let string = String(data: value, encoding: .utf8) {
            print("Value for characteristic \(characteristic.uuid.uuidString) is \(string)")
            NotificationCenter.default.post(name: Notification.Name("receivedData"), object: string)
        }
    }


    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("Failed to disconnect: \(error)")
        } else {
            print("Disconnected!")
        }
    }
}
