//
//  PodViewController.swift
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
import WebKit

class PodViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backBarItem: UIBarButtonItem!
    
    var pod = "diasp.org"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.navigationDelegate = self
        
        let url = URL(string: "https://" + pod)!
        print("url: \(url)")
        webView.load(URLRequest(url: url))
        self.title = pod
        backBarItem.isEnabled = webView.canGoBack
    }
    
    // MARK: - Web view

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        backBarItem.isEnabled = webView.canGoBack
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView didFinish")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        backBarItem.isEnabled = webView.canGoBack
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView didFail")
    }
    
    // MARK: - Actions
    
    @IBAction func backClicked(_ sender: Any) {
        print("backClicked")
        webView.goBack()
        backBarItem.isEnabled = webView.canGoBack
    }
}

