//
//  TabBarViewController.swift
//  FitfiApp
//
//  Created by Yan Yu on 2018-06-18.
//  Copyright © 2018 Fitfi. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import AudioToolbox

//It is first commit to harsh
class TabBarViewController: UITabBarController {
    var smallTrackingVC: UIViewController!
    var window: UIWindow!
    
    let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    
    //BLE model version
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
    var dataArray = [Double]()
    
    override func viewDidLoad() {
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 49.0

        super.viewDidLoad()
        print(UIDevice.modelName)
        print("Tab Bar Controller Loaded")
        
        if !hasLaunchedBefore {
            print("First Time Launch The Application")
            //MARL: Save default Exercise and Schedule Template
            saveExercises()
            saveScheduleTemplate()
            UserDefaults.standard.setValue(true, forKey: "hasLaunchedBefore")
        } else {
            print("Non-First Time Launch")
        }
        
        //For initialization VC from xib file
        smallTrackingVC = SmallTrackingViewController.init(nibName: "SmallTrackingViewController", bundle: nil)
        smallTrackingVC.view.frame = CGRect(x: 0, y: (height - tabBarHeight - 64 - 0.5), width: width, height: 64)
        
        print("BLE Version: \(bleVersion)")
        //
        centralManager = CBCentralManager(delegate: self, queue: nil)
//        let trackingVC = SmallTrackingViewController()
//  MARK: After Adding frame it become activate
//        smallTrackingVC.view.frame = CGRect(x: 0, y: 497.5, width: 375, height: 119)
//        subView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}

//MARK: - Search and Connect to BLE Device
//MARK: Central Manager
extension TabBarViewController: CBCentralManagerDelegate {
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
//        MARK: Add to ParentVC
        add(smallTrackingVC)
        blePeripheral.discoverServices([bleServiceCBUUID]) // CHANGE THIS VALUE
    }
    
    //MARK: Did Disconnect Peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Did Disconnected Peripheral")
        //MARK: Remove from ParentVC
        smallTrackingVC.remove()
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
extension TabBarViewController: CBPeripheralDelegate {
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
            
            //            print("Data: \(String(describing: String(data: characteristic.value!, encoding: .utf8)))")
            
            //Array of Data
            if Int(String(data[0])) == dataArrayCounter {
                let currentDataArray = String(managedData[1]).split(by: 6)
                for i in currentDataArray {
                    dataArray.append(Double(i)!)
                }
                
                if dataArrayCounter == 2 {
                    //                    writeToFile(dataArray)
                    print(dataArray)
                    dataArray.removeAll()
                    dataArrayCounter = 0
                } else {
                    dataArrayCounter += 1
                }
            }
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
}



//MARK: Save exercises to local database when first time launch the app
//TODO: Get internet connection save data from api

extension TabBarViewController {
    func saveExercises() {
        for exercise in Exercises {
            let newExercise = Exercise(context: self.context)
            newExercise.name = exercise["name"]
            newExercise.instructions = exercise["instructions"]
            newExercise.image = exercise["image"]
            newExercise.category = exercise["category"]
            newExercise.favorite = false
            save()
        }
    }
    
    func saveScheduleTemplate() {
        for day in dayOfWeek {
            let newSchedule = Schedule(context: context)
            newSchedule.dayOfWeek = day
            save()
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }
}

//MARK: Find Current Top VC
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

//MARK: Add to or Remove From Parrent VC Function
extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
