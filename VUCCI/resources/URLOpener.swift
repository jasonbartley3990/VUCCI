//
//  URLOpener.swift
//  VUCCI
//
//  Created by Jason bartley on 4/20/22.
//

import Foundation
import UIKit

final class URLOpener {
    static let shared = URLOpener()
    
    public func verifyUrl (urlString: String?) -> Bool {
       if let urlString = urlString {
           if let url = NSURL(string: urlString) {
               return UIApplication.shared.canOpenURL(url as URL)
           }
       }
       return false
   }
    
}
