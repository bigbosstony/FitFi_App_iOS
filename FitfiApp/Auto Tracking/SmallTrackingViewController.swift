//
//  SmallTrackingViewController.swift
//  FitfiApp
//
//  Created by YAN YU on 2018-07-16.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreBluetooth
import AudioToolbox
import Alamofire

class SmallTrackingViewController: UIViewController {
    
    var maxTrackingVC: MaxTrackingViewController?
    
    @IBOutlet weak var exerciseTypeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let modelName = UIDevice.modelName
    lazy var bleVersion = {
        return self.deviceModelToBLEVersion(modelName)
    }()
    
    func deviceModelToBLEVersion(_ deviceModel: String) -> Double {
        switch deviceModel {
        case "iPhone 5", "iPhone5c", "iPhone 5s":
            return 4.0
        case "iPhone 6", "iPhone 6 Plus", "iPhone 6s", "iPhone SE", "iPhone 6s Plus", "iPhone 7", "iPhone 7 Plus", "iPad 6":
            return 4.2
        case "iPhone 8", "iPhone 8 Plus", "iPhone X":
            return 5.0
        default:
            return 0.0
        }
    }
    //Setup COre Bluetooth Properties
    var centralManager: CBCentralManager!
    var blePeripheral: CBPeripheral!
    let bleServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")  //6E400001-B5A3-F393-E0A9-E50E24DCCA9E
    let bleCharacteristicCBUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    //
    var dataArrayCounter = 0
//    var dataRowCounter = 1
    var dataArray = [Double]()
//    var dataSourceString: String = ""
//    var file = "log.csv"
    let dateFormatter = DateFormatter()
//    var exerciseName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Device: ", UIDevice.modelName)
        print("BLE Version: \(bleVersion)")
//        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //Register nib file to collection view
        collectionView.register(UINib.init(nibName: "SmallTrackingVCCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "smallTrackingVCCVCell")
        collectionView.delegate = self
        collectionView.dataSource = self
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 6
//        collectionView.collectionViewLayout = layout
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandTrackingSmallView)) //Change This If Needed
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tap to expand
    @objc func expandTrackingSmallView() {
        maxTrackingVC = MaxTrackingViewController.init(nibName: "MaxTrackingViewController", bundle: nil)
        maxTrackingVC?.delegate = self
        present(maxTrackingVC!, animated: true, completion: nil)
    }
}


//MARK: - Search and Connect to BLE Device
//MARK: Central Manager
extension SmallTrackingViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {          //TODO: Change View isHidden to true Later
        case .unknown:
            print("central.state is .unknown")
            view.isHidden = true
        case .resetting:
            print("central.state is .resetting")
            view.isHidden = true
        case .unsupported:
            print("central.state is .unsupported")
            view.isHidden = false
        case .unauthorized:
            print("central.state is .unauthorized")
            view.isHidden = true
        case .poweredOff:
            print("central.state is .poweredOff")
            view.isHidden = true
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [bleServiceCBUUID]) // ????? [bleServiceCBUUID]
            print("Scanning...")
        }
    }
    
    //MARK: Did Discover Peipheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Did Discover Peripheral")
        print("name: ", peripheral.name!, "\nidentifier: ", peripheral.identifier, "\nstate: ", peripheral.state.rawValue)
        print("advData = \(advertisementData)")
        print("RSSI = \(RSSI)")
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        
        switch bleVersion {
        case 4.0:
            print("BLE: 4.0")
        case 4.2:
            print("BLE: 4.2")
            if -45...0 ~= RSSI.intValue {
                blePeripheral = peripheral
                blePeripheral.delegate = self
                //                centralManager.stopScan()
                centralManager.connect(blePeripheral)
            } else {
                centralManager.scanForPeripherals(withServices: [bleServiceCBUUID], options: nil)
            }
        case 5.0:
            print("BLE: 5.0")
            if RSSI.intValue > -35 {
                blePeripheral = peripheral
                blePeripheral.delegate = self
                //                centralManager.stopScan()
                centralManager.connect(blePeripheral)
            } else {
                centralManager.scanForPeripherals(withServices: [bleServiceCBUUID], options: nil)
            }
        case 0.0:
            print("No Way")
        default:
            print("Unknown")
        }
    }
    
    //MARK: Did Connect Peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Did Connect to Peripheral")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        //        MARK: Make Small TrackingVC Visable
        self.view.isHidden = false
        blePeripheral.discoverServices([bleServiceCBUUID]) // CHANGE THIS VALUE
    }
    
    //MARK: Did Disconnect Peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Did Disconnected Peripheral")
        //MARK: Make Small TrackingVC Hidden
        //        smallTrackingVC.remove()
        self.view.isHidden = true
        switch central.state {
        case .poweredOn:
            print("central.state is .poweredOn again")
            centralManager.scanForPeripherals(withServices: [bleServiceCBUUID], options: nil)
        default:
            print("bluetooth unavailable")
        }
    }
}

//MARK: CB Peripheral
extension SmallTrackingViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral.services!)
        guard let services = peripheral.services else { return }
        for service in services {
            print("Did Discover Service: \n \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("All Characteristic: ", characteristic)
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    //MARK: Update Characteristic Value
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case bleCharacteristicCBUUID:
            //                let realData = String(data!.suffix(17))
            
            guard let data = String(data: characteristic.value!, encoding: .utf8) else { return }
            let managedData = data.split{ [":", "\0"].contains($0.description) }
            
            //Array of Data
            if Int(String(data[0])) == dataArrayCounter {
                let currentDataArray = String(managedData[1]).split(by: 6)
                for i in currentDataArray {
                    dataArray.append(Double(i)!)
                }
                
                if dataArrayCounter == 2 {
                    //                    writeToFile(dataArray)
                    //MARK: Received Data Array
                    print("XYZ Data Array: ", dataArray)
                    dataArray.removeAll()
                    dataArrayCounter = 0
                } else {
                    dataArrayCounter += 1
                }
            }
            
//            print("Data: \(String(describing: String(data: characteristic.value!, encoding: .utf8)))")
            
            
            //Array of Data
//            if Int(String(data[0])) == dataArrayCounter {
//                let currentDataArray = String(managedData[1]).split(by: 6)
//                for i in currentDataArray {
//                    dataArray.append(i)
//                }
//                //MARK: Received Data Array
//                if dataArrayCounter == 2 {
//                    if dataRowCounter <= 50 {
////                        NSLog("Row: \(dataRowCounter) XYZ Data Array: \(dataArray)\n")
//                        //TODO: Append to the File
//                        let dataString = dataArray.joined(separator: ",") + "\n"
//                        print("Row: \(dataRowCounter)"," \(dataString)")
//                        dataSourceString.append(dataString)
//                        dataRowCounter += 1
//                    } else {
//                        //MARK: write to the file
//                        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                            let currentTime = Date()
//                            file = dateFormatter.string(from: currentTime) + ".csv"
//                            let fileURL = dir.appendingPathComponent(file)
//                            //writing
//                            do {
//                                try dataSourceString.write(to: fileURL, atomically: false, encoding: .utf8)
//                            }
//                            catch {/* error handling here */}
//
//                            //MARK: Upload File with Alamofire
//                            Alamofire.upload(multipartFormData: { multipartFormData in
//                                multipartFormData.append(fileURL, withName: "uploaded_file")
//                            }, to: "http://192.168.2.25/work/upload.php",
//                                encodingCompletion: { encodingResult in
//                                    switch encodingResult {
//                                    case .success(let upload, _,_ ):
//                                        upload.responseString { response in
//                                            debugPrint(response)
//                                        }
//                                    case .failure(let encodingError):
//                                        print(encodingError)
//                                    }
//                            })
//                        }
//                        dataSourceString = ""
//                        dataRowCounter = 1
//                    }
//                    dataArray.removeAll()
//                    dataArrayCounter = 0
//                } else {
//                    dataArrayCounter += 1
//                }
//            }
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
}

extension SmallTrackingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallTrackingVCCVCell", for: indexPath) as! SmallTrackingVCCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}

extension SmallTrackingViewController: MaxTrackingDelegate {
    var message: String {
        return "It's Working"
    }
}

extension SmallTrackingViewController {
    func uploadCSVFile() {
        let fileURL: String = "http://192.168.5.29/work/upload.php"
        guard let url = URL(string: fileURL) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
    }
}

//extension SmallTrackingViewController {
//    func makeGetCall() {
//        // Set up the URL request
//        let resultURL: String = "http://192.168.2.25/work/get_ename.php"
//
//        guard let url = URL(string: resultURL) else {
//            print("Error: cannot create URL")
//            return
//        }
//        let urlRequest = URLRequest(url: url)
//
//        // set up the session
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//
//        // make the request
//        let task = session.dataTask(with: urlRequest) {
//            (data, response, error) in
//            // check for any errors
//            guard error == nil else {
//                print("error calling GET on /gyms/0")
//                print(error!)
//                return
//            }
//            // make sure we got data
//            guard let responseData = data else {
//                print("Error: did not receive data")
//                return
//            }
//            print(responseData)
//
//            do {
//                guard let data = try JSONSerialization.jsonObject(with: responseData, options: [])
//                    as? [String: Any] else {
//                        print("error trying to convert data to JSON")
//                        return
//                }
//                //Set to Label
//                DispatchQueue.main.async {
//                    self.exerciseTypeLabel.text = data["e_name"] as? String
//                }
//
//            } catch  {
//                print("error trying to convert data to JSON")
//                return
//            }
//        }
//        task.resume()
//    }
//}


