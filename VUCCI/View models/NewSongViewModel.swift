//
//  NewSongViewModel.swift
//  VUCCI
//
//  Created by Jason bartley on 5/10/22.
//

import Foundation
import UIKit

struct NewSongViewModel {
    let name: String
    let audioData: Data?
    let songDuration: Double
    let coverImage: UIImage
    let songId: String
}
