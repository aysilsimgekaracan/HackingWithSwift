//
//  WebViewController.swift
//  Project16
//
//  Created by Ayşıl Simge Karacan on 3.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    
    var placeWiki: String!
    var placeName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let wiki = placeWiki else { return }
        guard let name = placeName else { return }
        
        title = name
        
        guard let wikiURL = URL(string: wiki) else { return }
        webView.load(URLRequest(url: wikiURL))
        
    }
    



}
