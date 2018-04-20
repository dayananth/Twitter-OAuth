//
//  ViewController.swift
//  TwitterOauth
//
//  Created by 河野純也 on 2018/04/20.
//  Copyright © 2018年 河野純也. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {
    
    var oauthswift: OAuthSwift?
    
    let consumerData: [String:String] = ["consumerKey": "", "consumerSecret": ""]
    
    @IBAction func twitterAuth(_ sender: UIButton) {
        doAuthTwitter(consumerData)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton()
        button.setTitle("Twitter OAuth", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.bounds = CGRect(x: 0, y: 0, width: 120, height: 30)
        button.center = self.view.center
        button.addTarget(self, action: #selector(ViewController.twitterAuth(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Twitter
    func doAuthTwitter(_ serviceParams: [String: String]) {
        let oauthswift = OAuth1Swift(consumerKey: serviceParams["consumerKey"]!, consumerSecret: serviceParams["consumerSecret"]!, requestTokenUrl: "https://api.twitter.com/oauth/request_token", authorizeUrl: "https://api.twitter.com/oauth/authorize", accessTokenUrl: "https://api.twitter.com/oauth/access_token")
        self.oauthswift = oauthswift
        oauthswift.authorize(withCallbackURL: URL(string: "TwitterOAuth://oauth-callback")!,
            success: { credential, response, parameters in
                self.showTokenAlert(name: serviceParams["name"], credential: credential)
            }, failure: { error in
                print(error.description)
            }
        )
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        if #available(iOS 9.0, *) {
            let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
            handler.presentCompletion = {
                print("Safari presented")
            }
            handler.dismissCompletion = {
                print("Safari dissmiss")
            }
            return handler
        }
        return OAuthSwiftOpenURLExternally.sharedInstance
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token: \(credential.oauthToken)"
        if !credential.oauthTokenSecret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauthTokenSecret)"
        }
        self.showAlertView(title: name ?? "Service", message: message)
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

