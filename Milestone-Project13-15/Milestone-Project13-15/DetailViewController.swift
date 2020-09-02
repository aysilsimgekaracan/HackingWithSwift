//
//  DetailViewController.swift
//  Milestone-Project13-15
//
//  Created by Ayşıl Simge Karacan on 2.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var webView: WKWebView!
    
    var countryDetail: Countries?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = countryDetail?.name
        
        let pictureURL = URL(string: countryDetail?.flag ?? "https://www.lifewire.com/thmb/Fv486WGxstZuE8OUNgmuBJZ6Ntg=/1200x800/filters:no_upscale():max_bytes(150000):strip_icc()/alert-icon-5807a14f5f9b5805c2aa679c.PNG")!
        
        webView.autoresizesSubviews = true
        webView.translatesAutoresizingMaskIntoConstraints = true
        webView.scrollView.isScrollEnabled = false
        webView.contentMode = .scaleAspectFit
        webView.backgroundColor = .clear

        webView.load(URLRequest(url: pictureURL))
        

        textView.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = """
        ISO 3166 Code: \(String(describing: countryDetail?.alpha2Code ?? " "))\n
        Capital: \(String(describing: countryDetail?.capital ?? " "))\n
        Region: \(String(describing: countryDetail?.region ?? " "))\n
        Subregion: \(String(describing: countryDetail?.subregion ?? " "))\n
        Population: \(String(describing: countryDetail?.population ?? 0))\n
        """
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
    }
    
    @objc func shareTapped() {
        let text = textView.text
        let vc = UIActivityViewController(activityItems: [title ?? "Unknown", text ?? "Unknown"], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
       }
    
}






