//
//  ViewController.swift
//  Project22
//
//  Created by Ayşıl Simge Karacan on 4.10.2020.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconTypeLabel: UILabel!
    @IBOutlet var circleView: UIView!
    
    var currentBeaconUuid: UUID?
    
    var isdetected = false
    //let beaconsList = ["Apple AirLocate 5A4BCFCE" : UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"), "Apple AirLocate E2C56DB5" : UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"), "Apple AirLocate 74278BDA" : UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")]
    
    var locationManager: CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        circleView.layer.zPosition = -1
        circleView.clipsToBounds = true
        circleView.layer.backgroundColor = UIColor.clear.cgColor
        circleView.layer.borderColor = UIColor.green.cgColor
        circleView.layer.borderWidth = 5
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        // Challenge - 2
//        addBeaconRegion(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "Apple AirLocate 5A4BCFCE")
//        addBeaconRegion(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", major: 123, minor: 456, identifier: "Apple AirLocate E2C56DB5")
//        addBeaconRegion(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935", major: 123, minor: 456, identifier: "Apple AirLocate 74278BDA")

        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion1 = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion1)
        //locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    
//    func addBeaconRegion(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
//        let uuid = UUID(uuidString: uuidString)!
//        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
//
//        locationManager?.startMonitoring(for: beaconRegion)
//        locationManager?.startRangingBeacons(in: beaconRegion)
//    }
    
    func update(distance: CLProximity, identifier: String) {
        UIView.animate(withDuration: 1) {
            self.beaconTypeLabel.text = identifier
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
            
        }
        
        // Challenge - 1
        
        if distance != .unknown {
            if !isdetected {
                let ac = UIAlertController(title: "Beacon is detected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(ac, animated: true, completion: nil)
                isdetected = true
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        
        if beacons.count > 0 {
            let beacon = beacons[0]
            //if currentBeaconUuid == nil { currentBeaconUuid = region.proximityUUID }
            //guard currentBeaconUuid == region.proximityUUID else { return }

            //update(distance: beacon.proximity, identifier: region.identifier)
            
            update(distance: beacon.proximity, identifier: "Apple AirLocate 5A4BCFCE")
        } else {
            //guard currentBeaconUuid == region.proximityUUID else { return }
            currentBeaconUuid = nil
            
            update(distance: .unknown, identifier: "There is No Beacon Located")
            
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
//
//    }

}

