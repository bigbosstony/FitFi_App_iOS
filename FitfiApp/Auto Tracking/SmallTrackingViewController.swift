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



//MARK: Testing
//struct CurrentExercise {
//    var name: String
//    var counts: [Int]
//
//    init(name: String, counts: [Int]) {
//        self.name = name
//        self.counts = counts
//    }
//}

class SmallTrackingViewController: UIViewController {
    
    var testingData = 0
    
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

    let bleMainServiceCharacteristic2WCBUUID = CBUUID(string: "6E400003-B5A2-F393-E0A9-E50E24DCCA9E")
    let bleMainServiceCharacteristic3NCBUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")

    let bleBattery = CBUUID(string: "2A19")
    let bleSystemID = CBUUID(string: "2A23")
    let bleManufacturerNameString = CBUUID(string: "2A29")
    let bleModelNumberString = CBUUID(string: "2A24")
    
    var identifier: String?
    //>>>>>>>>
    var globalCounter = 0
    
    var dataArrayCounter = 0
    var dataArray = [Double]()
    var dataArrayString = [String]()
    let dateFormatter = DateFormatter()
    let dataArrayCounterDictionary = [0: "A", 1: "G", 2: "M"]
    
    var username = ""
    
    //MARK: Create Core ML Model
    let countingModel = counting_model_0_4()
    let classifyModel = classify_model_0_4()
    
    //MARK: Testing
//    var currentExerciseArray = [CurrentExercise]()
    var counter = 0
    var currentExercise = ""
    
    //MARK: URL
//    let machineLearningURL : String = "http://35.173.192.211:5000"
    let machineLearningURL : String = "http://192.168.2.37:5000"
//    let machineLearningURL : String = "http://fitfi.vbjdqpfgmj.us-west-2.elasticbeanstalk.com"

    
    lazy var requestURL = {
       return URL(string: machineLearningURL)
    }()
    
    lazy var machineLearningURLRequest = {
        return URLRequest(url: requestURL ?? URL(string: "https://www.google.com")!)
    }()
    

//    var machineLearningURLRequest = URLRequest(url: requestURL)
//    machineLearningURLRequest.httpMethod = "POST"

    let fetchHelper = FetchDataHelper()
    var currentWorkoutExerciseArray = [CurrentWorkoutExercise]()
    var currentWorkoutUpdater = CurrentWorkoutUpdater()
    
    //TODO: Add to Struct
//    var currentExerciseName = ""
//    var currentExerciseIndex = 0
//    var totalCurrentExercise = 0
//
//    var currentSetIndex = 0
//    var totalSet4Exercise = 0
//
//    var currentCount = 0
//    var currentRep4Set: Int16 = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Small Tracking View Did Load")
        print("Device: ", UIDevice.modelName)
        print("BLE Version: \(bleVersion)")
        //        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        
        //MARK: Demo - Load CoreData to Struct
        if let demoRoutine = fetchHelper.loadDemoRoutine(with: "alpha").first {
            if let exerciseArray = demoRoutine.routineExercises?.array {
                for exercise in exerciseArray as! [Routine_Exercise] {
                    let setArray = [Int16](repeating: exercise.reps, count: Int(exercise.sets))
                    let setDoneArray = [Bool](repeating: false, count: Int(exercise.sets))
                    let weightArray = [Int16](repeating: 0, count: Int(exercise.sets))
                    
                    let newCurrentWorkoutExercise = CurrentWorkoutExercise(name: exercise.name!, category: exercise.category!, calorie: 0, setArray: setArray, setDoneArray: setDoneArray, weightArray: weightArray, done: false)
                    currentWorkoutExerciseArray.append(newCurrentWorkoutExercise)
                }
            }
            print("Demo")
            print(currentWorkoutExerciseArray)
            //
            currentWorkoutUpdater.currentExerciseName = currentWorkoutExerciseArray.first?.name ?? "none"
            currentWorkoutUpdater.currentRep4Set = currentWorkoutExerciseArray.first?.setArray.first ?? 0
            currentWorkoutUpdater.totalSet4Exercise = currentWorkoutExerciseArray.first?.setArray.count ?? 0
            currentWorkoutUpdater.totalCurrentExercise = currentWorkoutExerciseArray.count

//            currentExerciseName = currentWorkoutExerciseArray.first?.name ?? "none"
//            currentRep4Set = currentWorkoutExerciseArray.first?.setArray.first ?? 0
//            totalSet4Exercise = currentWorkoutExerciseArray.first?.setArray.count ?? 0
//            totalCurrentExercise = currentWorkoutExerciseArray.count
        }
        
        
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
        
        username = UserDefaults.standard.value(forKey: "phoneNumber") as! String
//        print("ST", username)
        //MARK: Testing

//        var currentExercise = CurrentExercise(name: "Biceps")
//        currentExercise.reps = 9
//        currentExercise.sets = 2
//        currentExerciseArray.append(currentExercise)
//        for i in 0..<y.count {
//            sleep(1)
//
//            postRequest(request: machineLearningURL, sensor: y[i])
//        }
        
        //
        exerciseTypeLabel.text = currentWorkoutExerciseArray.first?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Extend To MaxiTrackingView
    @objc func expandTrackingSmallView() {
        maxTrackingVC = MaxTrackingViewController.init(nibName: "MaxTrackingViewController", bundle: nil)
//        maxTrackingVC?.delegate = self
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

//        print("name: ", peripheral.name!)
//        print("identifier: ", peripheral.identifier)
//        print("state: ", peripheral.state.rawValue)
//        print("Services: ", peripheral.services as Any)
        print("AdvertismentData: ", advertisementData)
        
//        print("AdvertisementData Description: ", advertisementData.description)
        
//        print("AdvertisementData Keys: ", advertisementData.keys)

        print("RSSI = \(RSSI)")
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")
        
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        if hasLoginKey {
            switch bleVersion {
            case 4.0:
                print("BLE: 4.0")
            case 4.2:
                print("BLE: 4.2")

                if RSSI.intValue > -45 {

                    blePeripheral = peripheral
                    blePeripheral.delegate = self
                    //                centralManager.stopScan()
                    centralManager.connect(blePeripheral)
                } else {
                    centralManager.scanForPeripherals(withServices: [bleMainServiceCBUUID], options: nil)
                }
            case 5.0:
                print("BLE: 5.0")

                if -45...0 ~= RSSI.intValue {
                    
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
    }
    
    //MARK: Did Connect Peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Did Connect to Peripheral")
        
        username = UserDefaults.standard.value(forKey: "phoneNumber") as! String

        userLogin(with: username, url: machineLearningURL)

        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        //        MARK: Make Small TrackingVC Visable
        self.view.isHidden = false
        //MARK: IMPORTANT SERVICE UUID

        blePeripheral.discoverServices(nil) // CHANGE THIS VALUE IF NEEDED, nil == SEARCH FOR ALL SERVICES
        exerciseDeviceLabel.text = devices[peripheral.identifier.uuidString]
        
        central.stopScan()
        print("+++++")
        print(centralManager.retrieveConnectedPeripherals(withServices: [bleMainServiceCBUUID]))

        print("«««««««««««««««««««««««««««««««««««")
        print("identifier: ", peripheral.identifier)
        print("Local Name: ", peripheral.name ?? "")
        print("State: ", peripheral.state.rawValue)
//        print(peripheral.description)
//        print("RSSI: ", peripheral.readRSSI())
    }
    
    //MARK: Did Disconnect Peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Did Disconnected Peripheral")
        userLogout(from: machineLearningURL)
        exerciseDeviceLabel.text = ""
        //MARK: Make Small TrackingVC Hidden
        //        smallTrackingVC.remove()
        self.view.isHidden = true
//        userLogout(from: machineLearningURL)

        //MARK: Clean Counter and Exercise
        counter = 0
        exerciseCountingLabel.text = String(counter)
        exerciseTypeLabel.text = ""
        exerciseDeviceLabel.text = ""

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
        print(service)
        
        for characteristic in characteristics {
//            print("All Characteristic: ", characteristic)
            
            if characteristic.properties.contains(.notify) {
//                print("\(characteristic.uuid): properties contains .notify")
                if characteristic.uuid == bleMainServiceCharacteristic3NCBUUID {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
            
            if characteristic.uuid == bleManufacturerNameString {
                if let value = characteristic.value {
                    print("Manufacturer Name String: ", String(data: value, encoding: .utf8) ?? "None")
                }
            }

            if characteristic.uuid == bleModelNumberString {
                if let value = characteristic.value {
                    print("Model Number String: ", String(data: value, encoding: .utf8) ?? "None")
                }
            }

            if characteristic.uuid == bleSystemID {
                if let value = characteristic.value {
                    print("System ID: ", [UInt8](value))
                }
            }
            
            if characteristic.uuid == bleBattery {
                if let value = characteristic.value {
                    print("Battery Level: ",  [UInt8](value))
                }
            }
        }
    }
    
    //MARK: Update Characteristic Value
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Did Update Value For Characterristic")
        
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        if hasLoginKey {
            switch characteristic.uuid {
            case bleMainServiceCharacteristic3NCBUUID:
                let sensorData = getSensorData(from: characteristic, fA: 0.000061, fG: 0.00875, fM: 0.00014)
                
                dataArrayString = []
                
                for i in sensorData {
                    dataArrayString.append("\(i)")
                }
                
                print(dataArrayString)
                
                postRequest(request: machineLearningURL, sensor: dataArrayString)

    //        MARK: Battery Level
            case bleBattery:
                print("Battery Level value: ", [UInt8](characteristic.value!))
     
            default:
                print(characteristic.service.uuid)
                print("Unhandled Characteristic UUID: \(characteristic.uuid)")
    //            let data = String(data: characteristic.value!, encoding: .utf8)
            }
        } else {
            centralManager.cancelPeripheralConnection(peripheral)
            print("cancel connection")
        }
    }
}

extension SmallTrackingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallTrackingVCCVCell", for: indexPath) as! SmallTrackingVCCollectionViewCell
//        let exercise = currentWorkoutExerciseArray[currentExerciseIndex]
        let exercise = currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex]
        cell.exerciseReps.text = String(exercise.setArray[indexPath.row])
        cell.bottomBackground.backgroundColor = exercise.setDoneArray[indexPath.row] ? #colorLiteral(red: 0.9921568627, green: 0.9647058824, blue: 0.9490196078, alpha: 1) : #colorLiteral(red: 0.9215686275, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        return cell
        
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallTrackingVCCVCell", for: indexPath) as! SmallTrackingVCCollectionViewCell
//
//        let exercise = currentWorkoutExerciseArray[currentExerciseIndex]
//        cell.exerciseReps.text = String(exercise.setArray[indexPath.row])
        
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return currentExerciseArray.last?.counts.count ?? 0
//        return currentWorkoutExerciseArray[currentExerciseIndex].setArray.count
        return currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].setArray.count
    }
}

//extension SmallTrackingViewController: MaxTrackingDelegate {
//    func update(with number: Int) {
//        self.testingData = number
//    }
//
//
//    //Testing
//    var message: Int {
//        let random = arc4random_uniform(100)
//        return Int(random)
//    }
//
//
//}

extension SmallTrackingViewController {
//    func collectingController(exercise name: String) {
//        if currentExerciseArray.count == 0 {
//            print("Create and Add new exercise")
//            let newExercise = CurrentExercise(name: name, counts: [1])
//            currentExerciseArray.append(newExercise)
//            print("1: ", newExercise)
//
//        } else if currentExerciseArray.last?.name == name {
//            let indexOfExercise = currentExerciseArray.count - 1
//            let indexOfCounts = currentExerciseArray[indexOfExercise].counts.count - 1
//
//            if currentExerciseArray[indexOfExercise].counts[indexOfCounts] <= 5 {
//                currentExerciseArray[indexOfExercise].counts[indexOfCounts] += 1
//            } else {
//                currentExerciseArray[indexOfExercise].counts.append(1)
//            }
//            print("2: ", currentExerciseArray.last!)
//        } else {
//            let newExercise = CurrentExercise(name: name, counts: [1])
//            currentExerciseArray.append(newExercise)
//            print("3: ", currentExerciseArray.last!)
//        }
//    }
}


extension SmallTrackingViewController {
    
    func postRequest(request url: String, sensor data: [String]) {
        
        guard let requestURL = URL(string: url) else { print("URL Error"); return }
        
        var recievedData: [String: String] = ["" : ""]
        
        var machineLearningURLRequest = URLRequest(url: requestURL)
        machineLearningURLRequest.httpMethod = "POST"

        let sensorData: [String : Any] = ["username": username ,"data": data]
        print("Sensor Data: ", sensorData)
        
        do {
            let sensorJSONData : Data = try JSONSerialization.data(withJSONObject: sensorData, options: [])
            machineLearningURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            machineLearningURLRequest.httpBody = sensorJSONData

        } catch {
            print("Error: Can Not Create JSON Data")
        }

        let defaultSessionConfiguration = URLSessionConfiguration.default

        let session = URLSession(configuration: defaultSessionConfiguration)
        
        let task = session.dataTask(with: machineLearningURLRequest) { (data, urlResponse, error) in
            guard error == nil else { print("Error Calling POST \(String(describing: error))") ; return }
            
            guard let responseData = data else { print("Error Response Data"); return}
            
            do {
                guard let responseJSONData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : String] else { print("Can not get JSON as Dictionary") ; return }
                recievedData = responseJSONData

                print("Recieved Data: ", recievedData)
                
                //Update Label
                if let exercise = recievedData["exercise"] {
                    
                    print("Current Updater: ", self.currentWorkoutUpdater)
                    
                    //MARK: Send to Maxi View
                    self.testingData += 1
                    self.maxTrackingVC = MaxTrackingViewController.init(nibName: "MaxTrackingViewController", bundle: nil)
                    self.maxTrackingVC?.currentWorkoutUpdater = self.currentWorkoutUpdater
                    
                    DispatchQueue.main.async {

                        self.updateCurrentWorkout(with: exercise)

//                        self.collectingController(exercise: exercise)
//                        self.collectionView.reloadData()
//
//                        if self.currentExercise == exercise {
//                            self.exerciseTypeLabel.text = exercise
//                            self.counter += 1
//                            self.exerciseCountingLabel.text = String(self.counter)
//                        } else {
//                            self.currentExercise = exercise
//                            self.counter = 0
//                            self.exerciseTypeLabel.text = exercise
//                            self.counter += 1
//                            self.exerciseCountingLabel.text = String(self.counter)
//                        }
                    }
                }
            } catch {
                print("Error parsing response from POST")
                return
            }
        }
        task.resume()
    }
    
    func userLogin(with username: String, url: String) {
        
        guard let requestURL = URL(string: url + "/login") else { return }
        var loginRequestURL = URLRequest(url: requestURL)
        loginRequestURL.httpMethod = "POST"
        
        let username: [String : Any] = ["username": username]
        
        do {
            let usernameJSONData : Data = try JSONSerialization.data(withJSONObject: username, options: [])
            loginRequestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
            loginRequestURL.httpBody = usernameJSONData
        } catch {
            print("Error: Can Not Create JSON Data")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: loginRequestURL) { (data, urlResponse, error) in
            guard error == nil else { print("Error Calling POST \(String(describing: error))") ; return }
        }
        
        task.resume()
    }
    
    func userLogout(from url: String) {
        guard let requestURL = URL(string: url + "/logout") else { return }
        let logoutRequestURL = URLRequest(url: requestURL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: logoutRequestURL)
        task.resume()
    }
}

//Shifting...
extension SmallTrackingViewController {
    
    func getSensorData(from characteristic: CBCharacteristic ,fA: Float , fG: Float , fM: Float) -> [Float] {
        guard let characteristicData = characteristic.value else { return [1] }
        let byteArray = [UInt8](characteristicData)
        var accelerometerDataXYZ : [Float] = [0,0,0,0,0,0,0,0,0]
        var j = 0
        
        for i in 0...17 {
            
            if ( i % 2 == 0) {
                
                if ( i < 6) {
                    accelerometerDataXYZ[j] = Float((Int16(byteArray[i+1]) << 8) | (Int16(byteArray[i]))) * fA
                    j += 1
                }
                else if (i < 12 && i > 5) {
                    accelerometerDataXYZ[j] = Float((Int16(byteArray[i+1]) << 8) | (Int16(byteArray[i]))) * fG
                    j += 1
                }
                else if (i < 19 && i > 11) {
                    accelerometerDataXYZ[j] = Float((Int16(byteArray[i+1]) << 8) | (Int16(byteArray[i]))) * fM
                    j += 1
                }
            }
        }
        return accelerometerDataXYZ
    }
}

extension SmallTrackingViewController {
    
    func updateCurrentWorkout(with exercise: String) {
        
        if exercise == currentWorkoutUpdater.currentExerciseName {
            print("Current: ", currentWorkoutUpdater.currentExerciseName, currentWorkoutUpdater.currentCount)
//            DispatchQueue.main.async {
                self.exerciseCountingLabel.text = String(self.currentWorkoutUpdater.currentCount)
                self.collectionView.reloadData()
//            }
            
            if Int16(currentWorkoutUpdater.currentCount) < currentWorkoutUpdater.currentRep4Set {
                currentWorkoutUpdater.currentCount += 1
            } else {
                 currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].setDoneArray[currentWorkoutUpdater.currentSetIndex] = true
                if currentWorkoutUpdater.currentSetIndex + 1 < currentWorkoutUpdater.totalSet4Exercise {
                    currentWorkoutUpdater.currentSetIndex += 1
                    currentWorkoutUpdater.currentCount = 1
                    currentWorkoutUpdater.currentRep4Set = currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].setArray[currentWorkoutUpdater.currentSetIndex]
                } else {
                    currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].done = true
                    //Next Exercise
                    if currentWorkoutUpdater.currentExerciseIndex + 1 < currentWorkoutUpdater.totalCurrentExercise {
                        currentWorkoutUpdater.currentExerciseIndex += 1
                        //
                        exerciseTypeLabel.text = currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].name
                        
                        currentWorkoutUpdater.currentExerciseName = currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].name
                        currentWorkoutUpdater.currentSetIndex = 0
                        currentWorkoutUpdater.currentRep4Set = currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].setArray[currentWorkoutUpdater.currentSetIndex]
                        currentWorkoutUpdater.totalSet4Exercise = currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].setArray.count
                        currentWorkoutUpdater.currentCount = 1
                    } else {
                        currentWorkoutExerciseArray[currentWorkoutUpdater.currentExerciseIndex].done = true
                        print("Finish")
                        print(currentWorkoutExerciseArray)
                    }
                }
            }
        } else {
            print("Not Follow the Routine")
        }
    }
}

extension SmallTrackingViewController: URLSessionDelegate, URLSessionTaskDelegate {
    
}
