//
//  extensions.swift
//  VUCCI
//
//  Created by Jason bartley on 2/18/22.
//

import Foundation
import UIKit

extension UIView {
    var top: CGFloat {
        frame.origin.y
    }
    
    var bottom: CGFloat {
        frame.origin.y+height
    }
    var height: CGFloat {
        frame.size.height
    }
    var width: CGFloat {
        frame.size.width
    }
    var right: CGFloat {
        frame.origin.x+width
    }
    var left: CGFloat {
        frame.origin.x
    }
}

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return json
    }
}

extension Decodable {
    init?(with dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {return nil}
        guard let result = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        self = result
        
    }
}

extension Double {
    func timeInString() -> String {
        var minutes: Int = 0
        var seconds: String = ""
        
        let roundedTimeDouble = self
        var roundedtimeInt = Int(roundedTimeDouble)
        
        while (roundedtimeInt > 60) {
            roundedtimeInt -= 60
            minutes += 1
        }
        if roundedtimeInt == 0 {
            seconds = "00"
        } else if roundedtimeInt == 1 {
            seconds = "01"
        } else if roundedtimeInt == 2 {
            seconds = "02"
        } else if roundedtimeInt == 3 {
            seconds = "03"
        } else if roundedtimeInt == 4 {
            seconds = "04"
        } else if roundedtimeInt == 5 {
            seconds = "05"
        } else if roundedtimeInt == 6 {
            seconds = "06"
        } else if roundedtimeInt == 7 {
            seconds = "07"
        } else if roundedtimeInt == 8 {
            seconds = "08"
        } else if roundedtimeInt == 9 {
            seconds = "09"
        } else {
            seconds = "\(roundedtimeInt)"
        }
        
        return "\(minutes):\(seconds)"
        
    }
}

extension Double {
    func albumTimeInString() -> String {
        var hours: Int = 0
        var mins: Int = 0
        
        let roundedTimeDouble = self
        var roundedTimeInt = Int(roundedTimeDouble)
        
        while roundedTimeInt > 3600 {
            roundedTimeInt -= 3600
            hours += 1
        }
        
        while roundedTimeInt > 60 {
            roundedTimeInt -= 60
            mins += 1
        }
        
        if hours == 0 {
            if mins == 0 {
                return ""
            } else if mins == 1 {
                return "1 minute"
            } else {
                return "\(mins) minutes"
            }
        } else if hours == 1 {
            if mins == 0 {
                return "1 Hour"
            } else if mins == 1 {
                return "1 hour & 1 minute"
            } else {
                return "1 hour & \(mins) minutes"
            }
        } else {
            if mins == 0 {
                return "\(hours) hours"
            } else if mins == 1 {
                return "\(hours) hours & 1 minute"
            } else {
                return "\(hours) hours & \(mins) minutes"
            }
        }
        
    }
}

extension UIViewController {
    func addBlurToViewController() {
        var blurEffect: UIBlurEffect!
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: .dark)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    
    func removeBlurFromViewController() {
        for subView in self.view.subviews {
            if subView is UIVisualEffectView {
                subView.removeFromSuperview()
            }
        }
        
    }
}


