//
//  SecondViewController.swift
//  ios-stations
//

import UIKit
import WebKit
import Accounts
import SafariServices

class SecondViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var WKwebView: WKWebView!
    @IBOutlet weak var backToolBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var refreshToolBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var ActionToolBarButtonItem: UIBarButtonItem!
    
    @IBAction func backView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func backWebviewPage(_ sender: UIBarButtonItem) {
        WKwebView.goBack()
    }
    @IBAction func refreshWebviewPage(_ sender: UIBarButtonItem) {
        WKwebView.reload()
    }
    @IBAction func shareURL(_ sender: UIBarButtonItem) {
        guard let url: URL = WKwebView.url else {
            print("@IBAction func shareURL() にある guard let url: URL = WKwebView.url  においてreturnされました")
            return
        }
        
        let activityItems = [url] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems as [Any], applicationActivities: nil )
        
//        iPad対応
        if UIDevice.current.userInterfaceIdiom == .pad {
            if activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityVC.popoverPresentationController?.barButtonItem = sender
            }
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    @IBAction func openSafari(_ sender: UIBarButtonItem) {
        guard let url: URL = WKwebView.url else {
            print("@IBAction func openSafari() にある guard let url: URL = WKwebView.url  においてreturnされました")
            return
        }
        UIApplication.shared.open(url)
    }
    
//    private var webView: WKWebView!
//    private消した↓
    var receiveDataUrl: String!
    
    init(url: String) {
        self.receiveDataUrl = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
//        WKwebView = webView

        WKwebView.navigationDelegate = self
//        titleNavigationItem.title = WKwebView.title
//        titleNavigationItem.title = "unko"
        load(withURL: receiveDataUrl)
    }
    
    internal func webView(_ webView: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
//        guard let title: String =  else {
//            return
//        }
        titleNavigationItem.title = WKwebView.url?.absoluteString
    }
    
    private func load(withURL urlString: String) {
        guard let gotUrl = URL(string: urlString) else { return }
        
        WKwebView.load(URLRequest(url: gotUrl) as URLRequest)
    }
}
