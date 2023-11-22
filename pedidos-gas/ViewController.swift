//
//  ViewController.swift
//  pedidos-gas
//
//  Created by Alberto Lizarraga on 07/12/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIApplicationDelegate {
   /*
    let JSON = """nn
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
    
    */
       
    struct Datos: Codable {
                      
                    let telefono: String?
                    let apellidos: String?
                    let email: String?
                    let noConsumidor: String?
                    let nombres: String?
                    let identificador_externo: String?
                    let tipo: String?
                    let loggeado: String?
                }
   
   
    
    override func loadView() {
         
        
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
       
        
        self.reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onResume), name:
                UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func reloadView() {
        //do your initalisations here
        let url = URL(string:"http://localhost:3000")
        let request = URLRequest(url: url!)
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    
    @objc func onResume() {
        
         
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Resume")
        webView.reloadFromOrigin()
            
        }
    
    
    
    func webView(_ webView: WKWebView,
        didFinish navigation: WKNavigation!) {
        
         
        
        if UserDefaults.standard.string(forKey: "defTelefono") != nil {
            
            var defTelefono = UserDefaults.standard.string(forKey: "defTelefono") as! String
            var defConsumidor = UserDefaults.standard.string(forKey: "defConsumidor") as! String
            var defNombres = UserDefaults.standard.string(forKey: "defNombres") as! String
            var defApellidos = UserDefaults.standard.string(forKey: "defApellidos") as! String
            var defEmail = UserDefaults.standard.string(forKey: "defEmail") as! String
            var defIdentificador_externo = UserDefaults.standard.string(forKey: "defIdentificador_externo") as! String
            self.showToast(message: "Updating..." + defTelefono, seconds: 1.0)
            self.webView.evaluateJavaScript("{window.reactFunction1('\(defTelefono)','\(defConsumidor)','\(defNombres)','\(defApellidos)','\(defEmail)','\(defIdentificador_externo)');}") { (any, error) in
            print("Error : \(error)")
            }
             
            }else {
                
                return
            }
        
        
        
      }
    
    // Implement `WKScriptMessageHandler`，handle message which been sent by JavaScript
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if(message.name != "") {
                
                            print("JavaScript is sending a message \(message.body)")
                
               
             
                            let JSON = """
                                \(message.body)
                            """

                            let jsonData = JSON.data(using: .utf8)!

                            // Convert the JSON object to a Video object
                            let datos: Datos = try! JSONDecoder().decode(Datos.self, from: jsonData)
                            if(datos.tipo! as String == "1"){
                             print("guardar")
                                UserDefaults.standard.set(datos.telefono! as String, forKey:"defTelefono");
                                UserDefaults.standard.set(datos.noConsumidor! as String, forKey:"defConsumidor");
                                UserDefaults.standard.set(datos.nombres! as String, forKey:"defNombres");
                                UserDefaults.standard.set(datos.apellidos! as String, forKey:"defApellidos");
                                UserDefaults.standard.set(datos.email! as String, forKey:"defEmail");
                                UserDefaults.standard.set(datos.identificador_externo! as String, forKey:"defIdentificador_externo");
                                UserDefaults.standard.synchronize();
                            }else if(datos.tipo! as String == "0"){
                                print("no guardar")
                                UserDefaults.standard.removeObject(forKey: "defTelefono")
                                UserDefaults.standard.removeObject(forKey: "defConsumidor")
                                UserDefaults.standard.removeObject(forKey: "defNombres")
                                UserDefaults.standard.removeObject(forKey: "defApellidos")
                                UserDefaults.standard.removeObject(forKey: "defEmail")
                                UserDefaults.standard.removeObject(forKey: "defIdentificador_externo")
                                
                            }
                            
                 
            }
        }
    
    
    func showToast(message : String, seconds: Double){
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
            }
        }
}

