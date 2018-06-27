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

    var bicepsCounter = 0
    var tricepsCounter = 0
//    var accelerometerDataArray = [[Int]]()
    var accelerometerXArray = [Int](), accelerometerYArray = [Int](), accelerometerZArray = [Int]()

    @IBOutlet weak var mainCounter: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    
    var centralManager: CBCentralManager!
    var blePeripheral: CBPeripheral!
    
    let bleServiceCBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let bleService1CBUUID = CBUUID(string: "6E4001FE-B5A3-F393-E0A9-E50E24DCCA9E")
    let bleCharacteristicCBUUID = CBUUID(string: "6E4000FD-B5A3-F393-E0A9-E50E24DCCA9E") // CHANGE THIS VALUE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Central Manager Delegate
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Add Tap Gesture to the View
        let tap = UITapGestureRecognizer(target: self, action: #selector(smallViewCounterTappedToClear))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tapped Function To Clear
    @objc func smallViewCounterTappedToClear() {
        //########### Delete next line ############
        updateTrackingExercise(with: "Exercise", and: 0)
        clearAccelerometerDataArray()
        bicepsCounter = 0
        tricepsCounter = 0
    }
    
    // TODO: Update Counter Label
    func updateTrackingExercise(with exerciseName: String, and counter: Int) {
        
        exerciseLabel.text = exerciseName
        mainCounter.text = String(counter)
    }
}

//MARK: Central Manager
extension TrackingSViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
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
            centralManager.scanForPeripherals(withServices: [bleServiceCBUUID])
            print("Scanning...")
        }
    }
    
    //MARK: Did Discover Peipheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
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
        print("connected")
        view.isHidden = false
        blePeripheral.discoverServices([bleService1CBUUID]) // CHANGE THIS VALUE
    }
    
    //MARK: Did Disconnect Peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        view.isHidden = true
        print("disconnected")
        smallViewCounterTappedToClear()
        
        switch central.state {
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [bleServiceCBUUID], options: nil)
        default:
            print("bluetooth unavailable")
        }
    }
}

//MARK: CB Peripheral
extension TrackingSViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral.services)
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
    
    //Covert XYZ Value In Integer
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

// MARK: Algorithm
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
//        if accelerometerDataArray.count > 100 {
//            accelerometerDataArray.removeAll()
//        }
//        if xyzData[0] != 0 {
//            accelerometerDataArray.append(xyzData)
//            print(accelerometerDataArray)
            
//            max = accelerometerDataArray.map({ $0[2]}).max()!
//            min = accelerometerDataArray.map({ $0[2]}).min()!
            
//            if max - min > 1000 {
//                accelerometerDataArray.removeAll()
////                print(accelerometerDataArray)
//                counter += 1
//                if counter >= 3 {
//                    counter = 0
//                    repsCounter += 1
//                    mainCounter.text = String(repsCounter)
//                }
//
////                print(max, min)
//            }
//        }
        
        //        let indexOfMax = accelerometerDataArray.indices.filter{ accelerometerDataArray[$0][0] == max }
        
        
//        print(xArray)
//        print(accelerometerDataArray)

    
    
    // Z Array
    //            if accelerometerArray.count > 0 {
    //                print("Z Array: \(accelerometerZArray)")
    // ➢➢➢➢➢
    //                let indexOfMinValue = accelerometerZArray.index(of: accelerometerZArray.min()!)
    //                let indexOfMaxValue = accelerometerZArray.index(of: accelerometerZArray.max()!)
    //                let firstHalfCos = accelerometerZArray[..<indexOfMinValue!], secondHalfCos = accelerometerZArray[(indexOfMinValue! + 1)...]
    //                let firstHalfSin = accelerometerZArray[..<indexOfMaxValue!], secondHalfSin = accelerometerZArray[(indexOfMaxValue! + 1)...]
    
    // ➢➢➢➢➢ Checking Z Cos Value
    //                if firstHalfCos.count > 5 && secondHalfCos.count > 5 {
    //                    // For Biceps
    //                    let firstHalfMax = firstHalfCos.max(), secondHalfMax = secondHalfCos.max(), minimalInArray = accelerometerZArray[indexOfMinValue!]
    //                    let differenceCos = (firstHalfMax! + secondHalfMax!) / 2 - minimalInArray
    //                    let dividedCos = (firstHalfMax! + minimalInArray) / (secondHalfMax! + minimalInArray)
    //
    //                    // Matching Z Value
    //                    if 1 ... 2 ~= dividedCos && differenceCos > 1200 {
    //                        print("Min Value Index: \(String(describing: indexOfMinValue))" + "\(accelerometerZArray[indexOfMinValue!])")
    //                        updateTrackingExercise(with: "Biceps")
    //                        accelerometerZArray.removeAll()
    //
    //                    } else { print("Find no action") }
    //                }
    
    //  ➢➢➢➢➢ Checking Z Sin Value
    //                else if firstHalfSin.count > 5 && secondHalfSin.count > 5 {
    //                    // For Front Raise
    //                    let firstHalfMinimal = firstHalfSin.min(), secondHalfMinimal = secondHalfSin.min(), maxInArray = accelerometerZArray[indexOfMaxValue!]
    //                    let differenceSin = maxInArray - (firstHalfMinimal! + secondHalfMinimal!) / 2
    //                    let dividedSin = (firstHalfMinimal! + maxInArray) / (secondHalfMinimal! + maxInArray)
    //
    //                    if 1 ... 2 ~= dividedSin && differenceSin > 700 {
    //
    //                        updateTrackingExercise(with: "Front Raise")
    //                        accelerometerZArray.removeAll()
    //                    }
    //                }
    
    //                else { print("Nothing")}
    
    //            } else if accelerometerArray.count > 200 {
    //                accelerometerArray.removeAll()
    //            }
}
