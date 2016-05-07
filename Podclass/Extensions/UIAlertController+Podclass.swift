//
//  UIAlertController+Podclass.swift
//  Podclass
//
//  Created by Alan Scarpa on 5/7/16.
//  Copyright © 2016 Podclass. All rights reserved.
//

import Foundation



extension UIAlertController {
    enum Alert {
        case NoInternet
        case GenericError
    }
    func simpleAlert(type: Alert) -> UIAlertController {
        var title = ""
        var message = ""
        switch type {
        case .NoInternet:
            title = "No Internet"
            message = "You've lost your internet connection.  Please reconnect to keep learning!"
        case .GenericError:
            title = "Something Went Wrong"
            message = "We're sorry!  Something went wrong - please try again."
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancel)
        return alertController
    }
}