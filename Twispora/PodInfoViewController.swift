//
//  PodInfoViewController.swift
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

class PodInfoViewController: UIViewController {
    
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var uptimeLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var localPostsLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    var podData: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
    }
    
    func updateUI() {
        print("podData: \(podData)")
        self.title = podData["domain"] as? String
        statusValueLabel.text = podData["status"] as? String
        scoreValueLabel.text = podData["score"] as? String
        cityLabel.text = podData["city"] as? String
        if let uptime = podData["uptimelast7"] as? String {
            uptimeLabel.text = "\(uptime) %"
        }
        localPostsLabel.text = podData["local_posts"] as? String
        if let dateCreatedString = podData["datecreated"] as? String {
            let dateCompontents = dateCreatedString.components(separatedBy: " ")
            if dateCompontents.count > 0 {
                dateCreatedLabel.text = dateCompontents[0]
            }
        }
    }
    
    //MARK: - Actions
    
}

