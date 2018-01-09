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
    
    let defaultPod = "diasp.org"
    var pods: [[String:Any]]!
    var filteredPods: [[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    if let filePods = jsonResult["pods"] as? [[String:Any]] {
                        self.pods = filePods.filter{($0["hidden"] as? String) == "false"}.sorted {
                            if let domain1 = $0["domain"] as? String, let domain2 = $1["domain"] as? String {
                                return domain1 < domain2
                            }
                            return false
                        }
                        filteredPods = pods
                        print("filePods.count: \(filePods.count)")
                        print("filteredPods.count: \(pods.count)")
                    }
                }
            } catch {
                // handle error
                print("error: \(error)")
            }
        }
    }
    
    //MARK: - Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let podCell = tableView.dequeueReusableCell(withIdentifier: "PodCell") as! PodCell
        podCell.podLabel.text = filteredPods[indexPath.row]["domain"] as? String
        return podCell
    }
    
    //MARK: - Delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: \(searchText)")
        if searchText.isEmpty {
            filteredPods = self.pods
        } else {
            filteredPods = pods.filter {
                if let domain = $0["domain"] as? String {
                    return domain.range(of: searchText.lowercased()) != nil
                }
                return false
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func unwindToPodsViewController(_ segue: UIStoryboardSegue) {
        print("unwindToPodsViewController")
    }

}

