//
//  WebviewViewController.swift
//  ML_IOS
//
//  Created by Desktop-simranjeet on 07/12/21.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController {

    var webViewUrl:String?
    
    let webView: WKWebView = {
       let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var errorMessageLbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(errorMessageLbl)
        verifyUrl()
    }
    
    func verifyUrl()   {
        if (NSURL(string: webViewUrl!) != nil) {
                setUpWebView()
            }
        else {
            print("Not a QR barcode")
            errorMessageLbl.text = "Not a valid QR barcode"
        }
    }
    
    fileprivate func setUpWebView() {
        let request = URLRequest.init(url: URL.init(string: webViewUrl!)!)
        webView.navigationDelegate = self
        webView.load(request)
    }
   
}

//MARK:- Webview Delegates
extension WebviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}

//MARK:- Layout Views
extension WebviewViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30).isActive = true
        
        errorMessageLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        errorMessageLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
       
    }
}
