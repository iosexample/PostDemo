//
//  ViewController.swift
//  PostDemo
//
//  Created by dong on 25/1/2018.
//  Copyright © 2018 dong. All rights reserved.
//

import UIKit

extension String {
    var urlEncoded: String {
        var output = ""
        for thisChar in self.utf8 {
            switch thisChar {
            case UInt8(ascii: " "):
                output.append("+")
            case UInt8(ascii: "."), UInt8(ascii: "-"), UInt8(ascii: "_"), UInt8(ascii: "~"),
                 UInt8(ascii: "a")...UInt8(ascii: "z"),
                 UInt8(ascii: "A")...UInt8(ascii: "Z"),
                 UInt8(ascii: "0")...UInt8(ascii: "9"):
                output.append(Character(UnicodeScalar(UInt32(thisChar))!))
            default:
                output = output.appendingFormat("%%%02X", thisChar)
            }
        }
        return output
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func requestAction(_ sender: Any) {
        let url = URL(string: urlField.text!)
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var postString = "f=TEST&key="
        postString.append("power+".urlEncoded)
        postString.append("&r=")
        postString.append("u07OK2KVCjYbFSjus153ZJIVuGW8zGFfvLJgqKJqOU1WJjgdRXp75TI+kKFe5WOXe7wwSlDAeigKRy7E5LblefgOYe2ur34WTrJVXddrqVv7r1syfmJytZOcy9MS4S5VBe8LbqgBEv8Vxm89DS2JQH9htpa6IpoDeK6j1h1GY7b6nVvON2v5/StWhJ/uZHC4NTPr328UGAzz+fNclwXPXPNmjIancc6g6RNZOd08Gl4=".urlEncoded)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else { // check for fundamental networking error
                //                print("error=\(error)")
                DispatchQueue.main.async {
                    self.resultTextView.text = error.debugDescription
                }
                
                return
            }
            
            var resultText = ""
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //                print("response = \(response)")
                resultText = response.debugDescription
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                resultText.append(responseString)
            }
            //            print("responseString = \(responseString)")
            
            DispatchQueue.main.async {
                self.resultTextView.text = resultText
            }
        }
        
        task.resume()
    }


}

