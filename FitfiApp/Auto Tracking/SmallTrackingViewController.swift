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
import CoreML

//Exercise Type Dictionary
let exercise = [
    0 : "Triceps",
    1 : "Shoulder Press",
    2 : "Biceps",
    3 : "Lateral Raise",
    4 : "Triceps Kickback",
    5 : "Stationary Lunge",
    6 : "None"
]



let devices = [
    true : "Dumnbell 5lb",
    false : "Dumbbell 20lb"
]

//MARK: Testing
struct CurrentExercise {
    var name: String
    var counts: [Int]
    
    init(name: String, counts: [Int]) {
        self.name = name
        self.counts = counts
    }
}



class SmallTrackingViewController: UIViewController {
    
    var maxTrackingVC: MaxTrackingViewController?
    
    @IBOutlet weak var exerciseTypeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exerciseCountingLabel: UILabel!
    @IBOutlet weak var exerciseDeviceLabel: UILabel!
    
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
    
    //Setup Core Bluetooth Properties
    var centralManager: CBCentralManager!
    var blePeripheral: CBPeripheral!

    let bleMainServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")  //6E400001-B5A3-F393-E0A9-E50E24DCCA9E
    let bleMainServiceCharacteristicCBUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")

    let bleBattery = CBUUID(string: "2A19")
    let bleSystemID = CBUUID(string: "2A23")
    let bleManufacturerNameString = CBUUID(string: "2A29")
    let bleModelNumberString = CBUUID(string: "2A24")
    
    //>>>>>>>>
    var globalCounter = 0

    var dataArrayCounter = 0
    var dataArray = [Double]()
    let dateFormatter = DateFormatter()
    let dataArrayCounterDictionary = [0: "A", 1: "G", 2: "M"]
    
    //MARK: Create Core ML Model
    let countingModel = counting_model_0_4()
    let classifyModel = classify_model_0_4()
    
    //MARK: Testing
    var currentExerciseArray = [CurrentExercise]()
    var counter = 0
    var tempExercise = "Biceps"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Small Tracking View Did Load")
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
        
        //MARK: Testing
//        var currentExercise = CurrentExercise(name: "Biceps")
//        currentExercise.reps = 9
//        currentExercise.sets = 2
//        currentExerciseArray.append(currentExercise)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Extend To MaxiTrackingView
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
            view.isHidden = true
        case .unauthorized:
            print("central.state is .unauthorized")
            view.isHidden = true
        case .poweredOff:
            print("central.state is .poweredOff")
            view.isHidden = true
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [bleMainServiceCBUUID]) // ????? [bleServiceCBUUID]
            print("Scanning...")
        }
    }
    
    //MARK: Did Discover Peipheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("\nDid Discover Peripheral")
        print("name: ", peripheral.name!)
        print("identifier: ", peripheral.identifier)
        print("state: ", peripheral.state.rawValue)
        print("Services: ", peripheral.services)
        print("AdvertisementData Description: ", advertisementData.description)
        print("AdvertisementData Keys: ", advertisementData.keys)
        print("RSSI = \(RSSI)")
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")
        
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
                centralManager.scanForPeripherals(withServices: [bleMainServiceCBUUID], options: nil)
            }
        case 5.0:
            print("BLE: 5.0")
            if RSSI.intValue > -35 {
                blePeripheral = peripheral
                blePeripheral.delegate = self
                //                centralManager.stopScan()
                centralManager.connect(blePeripheral)
            } else {
                centralManager.scanForPeripherals(withServices: [bleMainServiceCBUUID], options: nil)
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
        //MARK: IMPORTANT SERVICE UUID
        blePeripheral.discoverServices(nil) // CHANGE THIS VALUE
        
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
            centralManager.scanForPeripherals(withServices: [bleMainServiceCBUUID], options: nil)
        default:
            print("bluetooth unavailable")
        }
    }
}

//MARK: CB Peripheral
extension SmallTrackingViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("«««««««««««««««««««")
        print(peripheral.services!)
        guard let services = peripheral.services else { return }
        for service in services {
            print("Did Discover Service: \(service)")
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
            } else if characteristic.uuid == bleManufacturerNameString {
                if let value = characteristic.value {
                    print("Manufacturer Name String: ", String(data: value, encoding: .utf8) ?? "None")
                }
            } else if characteristic.uuid == bleModelNumberString {
                if let value = characteristic.value {
                    print("Model Number String: ", String(data: value, encoding: .utf8) ?? "None")
                }
            } else if characteristic.uuid == bleSystemID {
                if let value = characteristic.value {
                    print("System ID: ", [UInt8](value))
                }
                
//                print("RSSI: ", peripheral.readRSSI())
//                print("System ID: ", String.init(String(data: characteristic.value!, encoding: .utf8)!))
            }
        }
    }
    
    //MARK: Update Characteristic Value
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case bleMainServiceCharacteristicCBUUID:
            //                let realData = String(data!.suffix(17))
             guard let data = String(data: characteristic.value!, encoding: .utf8) else { return }
             print(data)
            

            guard let data = String(data: characteristic.value!, encoding: .utf8) else { return }
            let newData = data.replacingOccurrences(of: "-", with: "+-")
            let managedData = newData.replacingOccurrences(of: "\r\n\n", with: "").split{ [":", "\0", " ", "+"].contains($0.description) }

            
//            print("Sensor Data: ", managedData)

            //Array of Data
//            if Int(String(data[0])) == dataArrayCounter {
            if String(data[0]) == dataArrayCounterDictionary[dataArrayCounter] {

//                let currentDataArray = String(managedData[1]).split(by: 6)
//                for i in currentDataArray {
//                    dataArray.append(round(1000 * Double(i)!) / 1000)
//                }
                for i in managedData[1...3] {
                    dataArray.append(round(1000 * Double(i)!) / 1000)
                }
                
                if dataArrayCounter == 2 {
                    //MARK: Testing Collection View Cell
//                    counter += 1
//
//                    if counter > 240 {
//                        tempExercise = "Triceps"
//                    }
//
//                    if counter % 30 == 0 {
//                        print(counter)
//
//                        collectingController(exercise: tempExercise)
//                    }
//
//                    collectionView.reloadData()
//                    exerciseTypeLabel.text = currentExerciseArray.last?.name
                    if globalCounter < sampleSensorData.count {
                        dataArray = sampleSensorData[globalCounter]
                    }
                    
                    globalCounter += 1
                    
                    //MARK: Add CoreML, Create CoreML Properties
                    let sensorInputData = try! MLMultiArray(shape: [9], dataType: .double)
//                    var outputArray = [Double]()
                    
                    for (index, data) in dataArray.enumerated() {
                        sensorInputData[index] = NSNumber(value: data)
                    }
                    
                    
                    //MARK: Input
//                    let input2 = tracking_model_0_2Input(input1: sensorInputData)
                    let input4Counting = counting_model_0_4Input(input1: sensorInputData)
                    
                    let input4Classify = classify_model_0_4Input(input1: sensorInputData)
                    
                    
                    if let predictionOutput4Counting = try? countingModel.prediction(input: input4Counting) {
                        
                        let output4Counting = predictionOutput4Counting.output1
                        
                        print("Prediction Counting Output: ", output4Counting)
                    
//                        for count in 0..<7 {
//                            outputArray.append(output[count].doubleValue)
//                        }
//                        let highestPrediction = outputArray.index(of: outputArray.max()!)!
//                        let highestExercise = exercise[highestPrediction]
//                        let highestExercisePrecetage = Double(round(1000 * outputArray.max()!) / 1000) * 100
//                        print(highestExercise!, highestExercisePrecetage)
//                        exerciseTypeLabel.text = highestExercise! + " " + String(highestExercisePrecetage) + "%"
                    }
                    
                    
                    if let predictionOutput4Classify = try? classifyModel.prediction(input: input4Classify) {
                        
                        let output4Counting = predictionOutput4Classify.output1
                        
//                        print("Prediction Classify Output: ", output4Counting)
                    }
                    
//                    print(dataArray)
                    
                    
                    dataArray.removeAll()
                    dataArrayCounter = 0
                } else {
                    dataArrayCounter += 1
                }
            }
            
        case bleBattery:

            print("Battery Level value: ", [UInt8](characteristic.value!))
        default:
           print(characteristic.service.uuid)
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
            let data = String(data: characteristic.value!, encoding: .utf8)
            print(data)
            
        }
    }
}

extension SmallTrackingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallTrackingVCCVCell", for: indexPath) as! SmallTrackingVCCollectionViewCell
        
        if let exercise = currentExerciseArray.last {
            cell.exerciseReps.text = String(exercise.counts[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentExerciseArray.last?.counts.count ?? 0
    }
}

extension SmallTrackingViewController: MaxTrackingDelegate {
    //Testing
    var message: Int {
        let random = arc4random_uniform(100)
        return Int(random)
    }
}

extension SmallTrackingViewController {
    func collectingController(exercise name: String) {
        if currentExerciseArray.count == 0 {
            print("Create and Add new exercise")
            let newExercise = CurrentExercise(name: name, counts: [1])
            currentExerciseArray.append(newExercise)
            print("1: ", newExercise)
            
        } else if currentExerciseArray.last?.name == name {
            let indexOfExercise = currentExerciseArray.count - 1
            let indexOfCounts = currentExerciseArray[indexOfExercise].counts.count - 1
            
            if currentExerciseArray[indexOfExercise].counts[indexOfCounts] <= 5 {
                currentExerciseArray[indexOfExercise].counts[indexOfCounts] += 1
            } else {
                currentExerciseArray[indexOfExercise].counts.append(1)
            }
            
            print("2: ", currentExerciseArray.last!)
        } else {
            let newExercise = CurrentExercise(name: name, counts: [1])
            currentExerciseArray.append(newExercise)
            print("3: ", currentExerciseArray.last!)
        }
    }
}

//extension SmallTrackingViewController {
//    func uploadCSVFile() {
//        let fileURL: String = "http://192.168.5.29/work/upload.php"
//        guard let url = URL(string: fileURL) else {
//            print("Error: cannot create URL")
//            return
//        }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//    }
//}


//MARK: Convert Data Format

//MARK: CoreML
/*
 1. Counting
 2. Classify
 */
