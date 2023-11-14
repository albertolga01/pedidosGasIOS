//
//  ViewController.swift
//  pedidos-gas
//
//  Created by Alberto Lizarraga on 07/12/22.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string:"https://pedidosgas.grupopetromar.com")
        let request = URLRequest(url: url!)
        webView.load(request)
    }


}

