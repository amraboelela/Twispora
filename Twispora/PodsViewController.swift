//
//  PodsViewController.swift
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

class PodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showInactivePodsSwitch: UISwitch!
    @IBOutlet weak var totalValueLabel: UILabel!
    //@IBOutlet weak var emailTextView: UITextView!
    
    let defaultPod = "diasp.org"
    var sortedPods: [[String:Any]]!
    var filteredPods: [[String:Any]]!
    var tableViewPods: [[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadData()
        searchBar.autocapitalizationType = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //emailTextView.dataDetectorTypes = .all
        updateData()
    }
    
    //MARK: - Overridden methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let podCell = sender as? PodCell {
            if let podVC = segue.destination as? PodViewController {
                    podVC.pod = podCell.podLabel.text ?? defaultPod
                }
        }
    }
    
    //MARK: - Data handling
    
    func loadData() {
        if let path = Bundle.main.path(forResource: "pods", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    if let pods = jsonResult["pods"] as? [[String:Any]] {
                        self.sortedPods = pods.sorted {
                            if let domain1 = $0["domain"] as? String, let domain2 = $1["domain"] as? String {
                                return domain1 < domain2
                            }
                            return false
                        }
                    }
                }
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    func updateData() {
        if self.showInactivePodsSwitch.isOn {
            self.filteredPods = sortedPods
        } else {
            self.filteredPods = sortedPods.filter{($0["hidden"] as? String) == "false"}
        }
        let searchText = searchBar.text?.lowercased() ?? ""
        if searchText.isEmpty {
            tableViewPods = filteredPods
        } else {
            tableViewPods = filteredPods.filter {
                if let domain = $0["domain"] as? String {
                    return domain.range(of: searchText.lowercased()) != nil
                }
                return false
            }
        }
        totalValueLabel.text = "\(tableViewPods.count)"
        print("filteredPods.count: \(filteredPods.count)")
        print("tableViewPods.count: \(tableViewPods.count)")
        tableView.reloadData()
    }
    
    //MARK: - Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewPods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let podCell = tableView.dequeueReusableCell(withIdentifier: "PodCell") as! PodCell
        podCell.podData = tableViewPods[indexPath.row]
        podCell.updateView()
        return podCell
    }
    
    //MARK: - Delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateData()
    }
    
    //MARK: - Actions
    
    @IBAction func inactivePodsSwitchValueChanged(_ sender: Any) {
        print("inactivePodsSwitchValueChanged")
        updateData()
    }
    
    @IBAction func unwindToPodsViewController(_ segue: UIStoryboardSegue) {
        print("unwindToPodsViewController")
    }

}

