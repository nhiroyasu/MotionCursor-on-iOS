import Foundation
import CoreBluetooth

let serviceUUID = CBUUID(string: "d84315a7-3e95-4da6-8110-c28285cd8e2b")
let mouseInfoCharacteristicUUID = CBUUID(string: "c7e75734-e6ab-11ea-adc1-0242ac120002")
let motionActionCharacteristicUUID = CBUUID(string: "b8a71aee-4e1c-4f4f-91da-4e10ce658cb0")

class BluetoothManager: NSObject, CBPeripheralManagerDelegate {
    static let shared = BluetoothManager()
    
    let motionInfoCharacteristic = CBMutableCharacteristic(type: mouseInfoCharacteristicUUID,
                                                           properties: .notify,
                                                           value: nil,
                                                           permissions: CBAttributePermissions.readable.union(.writeable))
    let motionActionCharacteristic = CBMutableCharacteristic(type: motionActionCharacteristicUUID,
                                                             properties: .notify,
                                                             value: nil,
                                                             permissions: CBAttributePermissions.readable.union(.writeable))
    let service = CBMutableService(type: serviceUUID, primary: true)
    var peripheralManager: CBPeripheralManager? = nil
    var central: CBCentral? = nil
    
    override init() {
        super.init()
        self.peripheralManager = CBPeripheralManager.init(delegate: self, queue: .global())
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("POWER ON")
            self.service.characteristics = [motionInfoCharacteristic, motionActionCharacteristic]
            self.peripheralManager?.add(service)
            if (!self.checkCharaConnection()) {
                // NOTE: 現在接続されていない時のみ宣伝する
                self.advertisement()
            }

        case .poweredOff:
            print("POWER OFF")
        default:
            print("STATE:", peripheral.state)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let e = error {
            print(e)
            return
        }
        
        print("succeeded to add service")
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let e = error {
            print(e)
            return
        }
        
        print("succeeded to start advertising")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Subscribe to", characteristic.uuid)
        self.central = central
        self.stopAdvertisement()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("read request")
        request.value = "HELLO BLUETOOTH".data(using: .utf8) ?? Data()
        peripheralManager?.respond(to: request, withResult: CBATTError.success)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("write request")
        for req in requests {
            print("DATA:",String(data: req.value ?? Data(), encoding: .utf8) ?? "")
            peripheralManager?.respond(to: req, withResult: CBATTError.success)
        }
    }
    
    
    
    // MARK: - Bluetooth Actions
    
    func advertisement() {
        let advertisementData = [
            CBAdvertisementDataServiceUUIDsKey: [service.uuid],
            CBAdvertisementDataLocalNameKey: "MyIOS"] as [String : Any]
        peripheralManager?.startAdvertising(advertisementData)
    }
    
    func stopAdvertisement() {
        print(self.checkCharaConnection())
        peripheralManager?.stopAdvertising()
    }
    
    
    func notifyMotionInfo(data: Data) {
        if (self.central != nil) {
            motionInfoCharacteristic.value = data
            let _ = peripheralManager?.updateValue(
                data,
                for: motionInfoCharacteristic,
                onSubscribedCentrals: nil)
        }
    }
    
    func notifyMotionAction(data: Data) {
        if (self.central != nil) {
            motionActionCharacteristic.value = data
            let _ = peripheralManager?.updateValue(
                data,
                for: motionActionCharacteristic,
                onSubscribedCentrals: nil)
        }
    }
    
    func disconnect() {
        self.peripheralManager?.removeAllServices()
    }
    
    
    // MARK: - Bluetooth Checks
    
    /**
     * 現在、characteristicが購読されている状態であるか
     * @return: true -> 購読中、false -> どれかが購読されていない
     */
    func checkCharaConnection() -> Bool {
        return
            self.motionInfoCharacteristic.subscribedCentrals?.count ?? 0 != 0 &&
            self.motionActionCharacteristic.subscribedCentrals?.count ?? 0 != 0
    }
}
