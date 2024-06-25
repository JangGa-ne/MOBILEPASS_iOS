//
//  AGREEMENT.swift
//  iBeacon
//
//  Created by i-Mac on 2020/10/06.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import WebKit

class AGREEMENT: UIViewController {
    
    var POSITION = 1
    
    @IBAction func BACK(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var WKWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AGREE_HTML(AGREE: POSITION)
    }
    
    func AGREE_HTML(AGREE: Int) {
        
        let HTML_PATH = Bundle.main.path(forResource: "terms\(AGREE)", ofType: "html")
        var HTML_STIRNG: String = ""
        do { HTML_STIRNG = try String(contentsOfFile: HTML_PATH!, encoding: .utf8) } catch { }
        let HTML_URL = URL(fileURLWithPath: HTML_PATH!)
        WKWebView.loadHTMLString(HTML_STIRNG, baseURL: HTML_URL)
    }
}

extension AGREEMENT: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}
