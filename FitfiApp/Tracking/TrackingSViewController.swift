//
//  TrackingSViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-12.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreBluetooth

class TrackingSViewController: UIViewController {

    //MARK: Properties
    var bicepsCounter = 0
    var tricepsCounter = 0
//    var accelerometerDataArray = [[Int]]()
    var accelerometerXArray = [Int](), accelerometerYArray = [Int](), accelerometerZArray = [Int]()

    //################################
    var counterLabel = UILabel()
    var exerciseLabel = UILabel()
    var deviceLabel = UILabel()
    var closeButton = UIButton()
    var workoutLabel = UILabel()
    var timeLabel = UILabel()
    var liveButton = UIButton()
    var liveImageView = UIImageView()

    //++++++++++++++++
    let dateFormatter = DateFormatter()
    var timer = Timer()
    
//    @IBOutlet weak var mainCounter: UILabel!
//    @IBOutlet weak var exerciseLabel: UILabel!
    
    // Tracking Max
//    var trackingMaxVC: UIViewController!
    
    var centralManager: CBCentralManager!
    var blePeripheral: CBPeripheral!
    
    let bleServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let bleService1CBUUID = CBUUID(string: "6E4001FE-B5A3-F393-E0A9-E50E24DCCA9E")
    let bleCharacteristicCBUUID = CBUUID(string: "6E4000FD-B5A3-F393-E0A9-E50E24DCCA9E") // CHANGE THIS VALUE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TrackingSViewController Loaded")
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        self.view.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        self.view.layer.shadowOpacity = 0.1
        self.view.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.view.layer.shadowRadius = 6
        
        counterLabel.frame = CGRect(x: 314, y: 0, width: 48, height: 86)
        counterLabel.text = "0"
        counterLabel.font = .systemFont(ofSize: 72, weight: .semibold)
        counterLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        exerciseLabel.frame = CGRect(x: 16, y: 16, width: 117, height: 23)
        exerciseLabel.text = "Becipes"
        exerciseLabel.font = .systemFont(ofSize: 19, weight: .semibold)
        exerciseLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        deviceLabel.frame = CGRect(x: 233, y: 90, width: 122, height: 20)
        deviceLabel.text = "5 lb Dumbbell"
        deviceLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        deviceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        workoutLabel.frame = CGRect(x: 126, y: 28, width: 134, height: 17)
        workoutLabel.text = "Afternoon Workout"
        workoutLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        workoutLabel.alpha = 0
        workoutLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        timeLabel.frame = CGRect(x: 136, y: 46, width: 145, height: 12)
        timeLabel.text = "TUESDAY JUN 28 12:16 PM"
        timeLabel.font = .systemFont(ofSize: 10, weight: .regular)
        timeLabel.alpha = 0
        timeLabel.textColor = #colorLiteral(red: 0.8352941176, green: 0.3725490196, blue: 0.1215686275, alpha: 1)
        
        closeButton.frame = CGRect(x: 335, y: 30, width: 28, height: 28)
        closeButton.alpha = 0
        if let image = UIImage(named: "Glyphs/Close") {
            closeButton.setImage(image, for: .normal)
        }
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        liveButton.frame = CGRect(x: 40, y: 513, width: 295, height: 42)
        liveButton.alpha = 0
        liveButton.addTarget(self, action: #selector(liveButtonTapped), for: .touchUpInside)
        liveButton.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.7725490196, blue: 0.7921568627, alpha: 1)
        liveButton.setTitle("Go Live", for: .normal)

        liveImageView.frame = CGRect(x: 0, y: 440, width: 375, height: 203)
        liveImageView.contentMode = .scaleAspectFill
        liveImageView.image = UIImage(named: "live")
        liveImageView.alpha = 0

        
        self.view.addSubview(counterLabel)
        self.view.addSubview(exerciseLabel)
        self.view.addSubview(deviceLabel)
        self.view.addSubview(closeButton)
        self.view.addSubview(workoutLabel)
        self.view.addSubview(timeLabel)
        self.view.addSubview(liveButton)
        self.view.addSubview(liveImageView)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        
        // Create Central Manager Delegate
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        // Add Tap Gesture to the View
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandTrackingSmallView)) //Change This If Needed
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update Time and Date
    @objc func updateTimeLabel() {
        let currentTime = Date()
        timeLabel.text = dateFormatter.string(from: currentTime)
//        print(dateFormatter.string(from: currentTime))
//        print(currentTime)
    }
    
    // Tapped Function To Clear
    @objc func smallViewCounterTappedToClear() {
        //########### Delete next line ############
        updateTrackingExercise(with: "Exercise", and: 0)
        clearAccelerometerDataArray()
        bicepsCounter = 0
        tricepsCounter = 0
    }
    
    // Tap to expand
    @objc func expandTrackingSmallView() {
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7) {
            self.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
            self.counterLabel.frame = CGRect(x: 152, y: 183, width: 72, height: 132)
            self.counterLabel.font = .systemFont(ofSize: 110, weight: .semibold)
            self.exerciseLabel.frame = CGRect(x: 151, y: 80, width: 117, height: 23)
            self.deviceLabel.frame = CGRect(x: 126, y: 363, width: 122, height: 20)
            self.closeButton.alpha = 1
            self.workoutLabel.alpha = 1
            self.timeLabel.alpha = 1
            self.liveButton.alpha = 1
        }
        animator.startAnimation(afterDelay: 0.0)
    }
    
    // Close Button Tapped
    @objc func closeButtonTapped() {
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7) {
            self.view.frame = CGRect(x: 0, y: 497.5, width: 375, height: 119)
            self.counterLabel.frame = CGRect(x: 314, y: 0, width: 48, height: 86)
            self.counterLabel.font = .systemFont(ofSize: 72, weight: .semibold)
            self.exerciseLabel.frame = CGRect(x: 16, y: 16, width: 117, height: 23)
            self.deviceLabel.frame = CGRect(x: 233, y: 90, width: 122, height: 20)
            self.closeButton.alpha = 0
            self.workoutLabel.alpha = 0
            self.timeLabel.alpha = 0
            self.liveButton.alpha = 0
            self.liveImageView.alpha = 0
        }
        
        animator.startAnimation(afterDelay: 0.0)
    }
    
    @objc func liveButtonTapped() {
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7) {
            self.liveButton.alpha = 0
            self.liveImageView.alpha = 1
        }
        animator.startAnimation(afterDelay: 0.3)
    }
    
//    @objc func expandTrackingSmallView() {
//        trackingMaxVC = TrackingMaxViewController.init(nibName: "TrackingMaxViewController", bundle: nil)
//        present(trackingMaxVC, animated: true)
//    }
    
    // TODO: Update Counter Label
    func updateTrackingExercise(with exerciseName: String, and counter: Int) {
        
        exerciseLabel.text = exerciseName
        counterLabel.text = String(counter)
    }
    
    func disconnectBLE() {
        centralManager.cancelPeripheralConnection(blePeripheral)
    }
}


//MARK: - Search and Connect to BLE Device
//MARK: Central Manager
extension TrackingSViewController: CBCentralManagerDelegate {
    
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
            centralManager.scanForPeripherals(withServices: [bleService1CBUUID]) // ?????
            print("Scanning...")
        }
    }
    
    //MARK: Did Discover Peipheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Did Discover Peripheral")
        
        print("peropheral = \(peripheral)")
        print("advData = \(advertisementData)")
        print("RSSI = \(RSSI)")
        
        blePeripheral = peripheral
        blePeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(blePeripheral)
    }
    
    //MARK: Did Connect Peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Did Connect to Peripheral")
        view.isHidden = false
        blePeripheral.discoverServices([bleService1CBUUID]) // CHANGE THIS VALUE
    }
    
    //MARK: Did Disconnect Peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        view.isHidden = true
        print("Did Disconnected Peripheral")
        smallViewCounterTappedToClear()
        
        switch central.state {
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [bleService1CBUUID], options: nil)
        default:
            print("bluetooth unavailable")
        }
    }
}

//MARK: CB Peripheral
extension TrackingSViewController: CBPeripheralDelegate {
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
            print(characteristic)
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
                //              print(characteristic.value!)
            }
        }
    }
    
    //MARK: Update Characteristic Value
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case bleCharacteristicCBUUID:
//            let characteristicIntData = getAccelerometerData(from: characteristic)
            matchingAccelerometerData(xyzData: getAccelerometerData(from: characteristic))
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
}

//MARK: Covert XYZ Value In Integer
extension TrackingSViewController {
    
    private func getAccelerometerData(from characteristic: CBCharacteristic) -> [Int] {
        guard let characteristicData = characteristic.value else { return [1] }
        let byteArray = [UInt8](characteristicData)
        var accelerometerDataXYZ = [Int]()
        
        print("Array: \(byteArray)")
        
        //Add X
        if byteArray[12] == 1 {
            accelerometerDataXYZ.append((Int(byteArray[1]) << 8) + Int(byteArray[0]))
        } else if byteArray[12] == 0 {
            accelerometerDataXYZ.append(-(Int(byteArray[1]) << 8) + Int(byteArray[0]))
        } else {
            accelerometerDataXYZ.append(0)
        }
        
        //Add Y
        if byteArray[13] == 1 {
            accelerometerDataXYZ.append((Int(byteArray[3]) << 8) + Int(byteArray[2]))
        } else if byteArray[13] == 0 {
            accelerometerDataXYZ.append(-(Int(byteArray[3]) << 8) + Int(byteArray[2]))
        } else {
            accelerometerDataXYZ.append(0)
        }
        
        //Add Z
        if byteArray[14] == 1 {
            accelerometerDataXYZ.append((Int(byteArray[5]) << 8) + Int(byteArray[4]))
        } else if byteArray[14] == 0 {
            accelerometerDataXYZ.append(-(Int(byteArray[5]) << 8) + Int(byteArray[4]))
        } else {
            accelerometerDataXYZ.append(0)
        }
        
        return accelerometerDataXYZ
    }
}

// ◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥◣◥
// MARK: Algorithm - Tracking Exercise
extension TrackingSViewController {
    func matchingAccelerometerData(xyzData: [Int]) {
        
        print("➢➣➢➣➢ 【-x-】: \(xyzData[0]), ➢➣➢➣➢ 【-y-】: \(xyzData[1]), ➢➣➢➣➢ 【-z-】: \(xyzData[2])\n")

        // Add X,Y,Z Data into Array
        accelerometerXArray.append(xyzData[0])
        accelerometerYArray.append(xyzData[1])
        accelerometerZArray.append(xyzData[2])
        
        if accelerometerZArray.count > 400 {
            clearAccelerometerDataArray()
        }
        
        if accelerometerXArray.count > 0 && accelerometerYArray.count > 0 && accelerometerZArray.count > 0 {
            // $$ Find Max and Min Value in each array
            // For X
            let indexOfMaxValueInXArray = accelerometerXArray.index(of: accelerometerXArray.max()!)
            let firstHalfOfXArray = accelerometerXArray[..<indexOfMaxValueInXArray!], secondHalfOfXArray = accelerometerXArray[(indexOfMaxValueInXArray! + 1)...]
            
            // For Y
            let indexOfMinValueInYArray = accelerometerYArray.index(of: accelerometerYArray.min()!)
            let firstHalfOfYArray = accelerometerYArray[..<indexOfMinValueInYArray!], secondHalfOfYArray = accelerometerYArray[(indexOfMinValueInYArray! + 1)...]
            
            //For Z
//            let indexOfMinValueInZArray = accelerometerZArray.index(of: accelerometerZArray.min()!)
//            let firstHalfOfZArray = accelerometerZArray[..<indexOfMinValueInZArray!], secondHalfOfZArray = accelerometerZArray[(indexOfMinValueInZArray! + 1)...]
            
            if firstHalfOfXArray.count > 2 && secondHalfOfXArray.count > 2 && firstHalfOfYArray.count > 2 && secondHalfOfYArray.count > 2 {
                // Find The Max or Min Value for each half of the array
                // For X
                let firstHalfMinValueOfX = firstHalfOfXArray.min()
                let secondHalfMinValueOfX = secondHalfOfXArray.min()
                let maxXValueInXArray = accelerometerXArray[indexOfMaxValueInXArray!] // might change
                let differenceValueFromMaxToMinX = maxXValueInXArray - (firstHalfMinValueOfX! + secondHalfMinValueOfX!) / 2
                let symmetricValueOfXArray = (firstHalfMinValueOfX! + maxXValueInXArray) - (secondHalfMinValueOfX! + maxXValueInXArray)
                // For Y
                let firstHalfMaxValueOfY = firstHalfOfYArray.max()
                let secondHalfMaxValueOfY = secondHalfOfYArray.max()
                let minYValueInYArray = accelerometerYArray[indexOfMinValueInYArray!] // might change
                let differenceValueFromMaxToMinY = (firstHalfMaxValueOfY! + secondHalfMaxValueOfY!) / 2  - minYValueInYArray
                let symmetricValueOfYArray = (firstHalfMaxValueOfY! + minYValueInYArray) - (secondHalfMaxValueOfY! + minYValueInYArray)
                
                // For Z
//                let firstHalfMaxValueOfZ = firstHalfOfZArray.max()
//                let secondHalfMaxValueOfZ = secondHalfOfZArray.max()
//                let minZValueInZArray = accelerometerZArray[indexOfMinValueInZArray!] // might change
//                let differenceValueFromMaxToMinZ = (firstHalfMaxValueOfZ! + secondHalfMaxValueOfZ!) / 2  - minZValueInZArray
//                let symmetricValueOfZArray = (firstHalfMaxValueOfZ! + minZValueInZArray) - (secondHalfMaxValueOfZ! + minZValueInZArray)
                
                if differenceValueFromMaxToMinX > 1300 { //&& -1 ... 1 ~= symmetricValueOfXArray {
                    print(symmetricValueOfXArray) 
                    bicepsCounter += 1
                    updateTrackingExercise(with: "Biceps", and: bicepsCounter)
                    clearAccelerometerDataArray()
                }
                
                else if differenceValueFromMaxToMinY > 1200 {
                    print(symmetricValueOfYArray)
                    tricepsCounter += 1
                    updateTrackingExercise(with: "Triceps", and: tricepsCounter)
                    clearAccelerometerDataArray()
                }
                
//                else if 600 ... 1200 ~= differenceValueFromMaxToMinZ {  //&& -1 ... 1 ~= symmetricValueOfZArray {
//                    print(symmetricValueOfZArray)
//                    frontRaiseCounter += 1
//                    updateTrackingExercise(with: "Front Raise", and: frontRaiseCounter)
//                    clearAccelerometerDataArray()
//                }
            }
        }
    }
    
    func clearAccelerometerDataArray() {
        accelerometerXArray.removeAll()
        accelerometerYArray.removeAll()
        accelerometerZArray.removeAll()
    }
}





