//
//  ViewController.swift
//  pedidos-gas
//
//  Created by Alberto Lizarraga on 07/12/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
   /*
    let JSON = """
    {
        "telefono":"47093",
        "noConsumidor":"47093,
        "nombres":"nombres",
        "apellidos":"apellidos",
        "email":"email",
        "identificador_externo":"identificador_externo",
        "loggeado":"1"
    }
    """
*/
    
    struct BlogPost: Decodable {
        enum Category: String, Decodable {
            case swift, combine, debugging, xcode
        }

        var defTelefono: Int
        var defConsumidor: Int
        var defNombres: String
        var defApellidos: String
        var defEmail: String
        var defIdentificador_externo: String
        var defLoggeado: Int
    }
    
    override func loadView() {
        
        var defTelefono = "defTelefono"
        var defConsumidor = "consumidor"
        var defNombres = "nombres"
        var defApellidos = "apellidos"
        var defEmail = "email"
        var defIdentificador_externo = "idexterno"
        
        UserDefaults.standard.set(defTelefono, forKey:"defTelefono");
        UserDefaults.standard.set(defConsumidor, forKey:"defConsumidor");
        UserDefaults.standard.set(defNombres, forKey:"defNombres");
        UserDefaults.standard.set(defApellidos, forKey:"defApellidos");
        UserDefaults.standard.set(defEmail, forKey:"defEmail");
        UserDefaults.standard.set(defIdentificador_externo, forKey:"defIdentificador_externo");
        UserDefaults.standard.synchronize();
        
          let webConfiguration = WKWebViewConfiguration()
          let contentController = WKUserContentController()
          // Inject JavaScript which sending message to App
          let js: String = "window.webkit.messageHandlers.callbackHandler.postMessage();"
          let userScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
          contentController.removeAllUserScripts()
          contentController.addUserScript(userScript)
          // Add ScriptMessageHandler
          contentController.add(
              self,
              name: "callbackHandler"
          )

          webConfiguration.userContentController = contentController

          webView = WKWebView(frame: .zero, configuration: webConfiguration)
          webView.uiDelegate = self
          webView.navigationDelegate = self
          view = webView
      }
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string:"http://localhost:3000")
        let request = URLRequest(url: url!)
        webView.navigationDelegate = self
        webView.load(request)
         
    }
   
    func webView(_ webView: WKWebView,
        didFinish navigation: WKNavigation!) {
        print("loaded")
        
        
        var defTelefono = UserDefaults.standard.string(forKey: "defTelefono") as! String
        let defConsumidor = UserDefaults.standard.string(forKey: "defConsumidor") as! String
        let defNombres = UserDefaults.standard.string(forKey: "defNombres") as! String
        let defApellidos = UserDefaults.standard.string(forKey: "defApellidos") as! String
        let defEmail = UserDefaults.standard.string(forKey: "defEmail") as! String
        let defIdentificador_externo = UserDefaults.standard.string(forKey: "defIdentificador_externo") as! String
        
        
        
        
        print(defTelefono)
        /*
        self.webView.evaluateJavaScript("{window.reactFunction1('\(defTelefono)','\(defConsumidor)','\(defNombres)','\(defApellidos)','\(defEmail)','\(defIdentificador_externo)');}") { (any, error) in
        print("Error : \(error)")
        }*/
      }
    
    // Implement `WKScriptMessageHandler`，handle message which been sent by JavaScript
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if(message.name != "") {
                //let jsonData = JSON.data(using: String.Encoding.utf8)!
                //let blogPost: BlogPost = try! JSONDecoder().decode(BlogPost.self, from: jsonData)

                print("JavaScript is sending a message \(message.body)")
            }
        }
}

