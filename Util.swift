//
//  Util.swift
//  music_sharing_iosapp
//
//  Created by Denis on 6/23/17.


import Foundation
import StoreKit

/*
 *  compare two date string in format "MM/dd/yyyy"
 */
func compareDateString(ds1: String, ds2: String) -> Bool {
    // d fomrmat: [m, d, y]
    let d1 = ds1.components(separatedBy: "-")
    let d2 = ds2.components(separatedBy: "-")
    
    let std_ds1 = d1[2] + d1[0] + d1[1]
    let std_ds2 = d2[2] + d2[0] + d2[1]
    
    return std_ds1 > std_ds2
}


func dateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    return dateFormatter.string(from: date)
}

/*
 * Utils to handle search string in user defaults
 */

func lastSearchObject() -> NSDictionary {
    if let searchObject = UserDefaults.standard.object(forKey: "lastSearch") {
        return searchObject as! NSDictionary
    }
    return NSDictionary()
}

func setLastSearchObject(searchObject: NSDictionary) {
    UserDefaults.standard.set(searchObject, forKey: "lastSearch")
    UserDefaults.standard.synchronize()
}

/*
 * Utils to handle search string in user defaults
 */

func isWithinTMin() -> Bool {
    if let lastActiveTime = UserDefaults.standard.object(forKey: "lastActiveTime") {
        let timeInterval = Date().timeIntervalSince(lastActiveTime as! Date)
		// time before hiding Last Search button (10 minutes)
        if timeInterval < 600 {  
            return true
        } else {
            return false
        }
    } else {
        return false
    }
    
}

func setLastActiveTime() {
    UserDefaults.standard.set(Date(), forKey: "lastActiveTime")
    UserDefaults.standard.synchronize()
}

/*
 * Utils to handle premium flag in user defaults
 */

func premiumStatus() -> PremiumStatus {    
    let status  = UserDefaults(suiteName: "group.com.datingdna.clipishsounds")?.string(forKey: "premium_status")
    if let status = status {
        switch status {
        case "yes":
            return .yes
        case "no":
            return .no
        default:
            return .empty
        }
    }
    else {
        return .empty
    }
}

func setPremiumStatus(status: PremiumStatus) {
    var statusStr = ""
    switch status {
    case .yes:
        statusStr = "yes"
    case .no:
        statusStr = "no"
    default:
        statusStr = "empty"
    }
    UserDefaults(suiteName: "group.com.datingdna.clipishsounds")?.set(statusStr, forKey: "premium_status")
}

/*
 * Utils to handle IAP
 */


func requestProductInfo(delegate: SKProductsRequestDelegate, vc: UIViewController) {
    if SKPaymentQueue.canMakePayments() {
        let productRequest = SKProductsRequest(productIdentifiers: Set(["CLIPishSoundsPrem"]))
        
        productRequest.delegate = delegate
        productRequest.start()
    }
    else {
        let alert = UIAlertController(title: "Failed", message: "Cannot perform In App Purchases.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
}

func showFailedAlert(type: FailedAlertType, vc: UIViewController) {
    switch type {
    case .purchase:
        let alert = UIAlertController(title: "Purchase Failed", message: "Purchase failed, please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        
    case .restore:
        let alert = UIAlertController(title: "Restore Failed", message: "Apple does not show a record of the Premium feature having been purchased with your Apple ID.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
