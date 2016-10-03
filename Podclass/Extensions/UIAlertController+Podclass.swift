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
        case noInternet
        case genericError
    }
    func simpleAlert(_ type: Alert) -> UIAlertController {
        var title = ""
        var message = ""
        switch type {
        case .noInternet:
            title = "No Internet"
            message = "You've lost your internet connection.  Please reconnect to keep learning!"
        case .genericError:
            title = "Something Went Wrong"
            message = "We're sorry!  Something went wrong - please try again."
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        return alertController
    }
}
