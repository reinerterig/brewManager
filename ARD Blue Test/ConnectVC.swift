import UIKit
import CoreBluetooth


class ConnectVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(startScan), for: .valueChanged)
        self.refreshControl = refreshControl
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("reloadTableView"), object: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BrevilleManager.shared.peripherals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let peripheral = Array(BrevilleManager.shared.peripherals.values)[indexPath.row]
        cell.textLabel?.text = peripheral.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = Array(BrevilleManager.shared.peripherals.values)[indexPath.row]
        BrevilleManager.shared.connectToPeripheral(peripheral)
    }

    @objc func startScan() {
        BrevilleManager.shared.startScan()
        self.refreshControl?.endRefreshing()
    }

    @objc func reloadTableView() {
        tableView.reloadData()
    }
}
