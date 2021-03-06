//
//  PodCell.swift
//  Twispora
//
//  Created by Amr Aboelela on 1/9/18.
//  Copyright © 2018 Twispora
//
//  Licensed under the Apache License, Version 2.0 (the “License”);
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an “AS IS” BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

class PodCell: UITableViewCell {
    
    @IBOutlet weak var podLabel: UILabel!

    var podData: [String: Any]?
    
    func updateView() {
        guard let podData = podData else {
            print("error: podData is nil")
            return
        }
        podLabel.text = podData["domain"] as? String
        if (podData["status"] as? String) == "4" {
            podLabel.textColor = UIColor.gray
        } else {
            podLabel.textColor = UIColor.blue
        }
    }
}
