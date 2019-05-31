//
//  ViewController.swift
//  What'sTheWeather
//
//  Created by Mahieu Bayon on 11/04/2018.
//  Copyright © 2018 M4m0ut. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var previsonLabel: UILabel!
    
    @IBAction func submit(_ sender: Any) {
  
        if var city = cityTextField.text {
            if city.contains(" ") {
                let tempCity = NSString(string: city)
                city = String(tempCity.replacingOccurrences(of: " ", with: "-"))
            }
            if let url = URL(string: "https://weather-forecast.com/locations/\(city)/forecasts/latest") {
                let request = NSMutableURLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print("error")
                    }
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        DispatchQueue.main.sync(execute: {
                            if (dataString?.contains("The page you were looking for doesn't exist"))! {
                                self.previsonLabel.text = "The weather there couldn't be found ! Please try again."
                            }
                            else {
                                var prevision: NSString?
                                if let range = dataString?.range(of: "</h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\"") {
                                    prevision = NSString(string: (dataString?.substring(from: (range.upperBound + 1)))!)
                                }
                                if let range = prevision?.range(of: "</span></p>") {
                                    prevision = NSString(string: (prevision?.substring(to: range.lowerBound))!)
                                    prevision = NSString(string: (prevision?.replacingOccurrences(of: "&deg;", with: "\u{00B0}"))!)
                                    self.previsonLabel.text = String(prevision!)
                                }
                            }
                        })
                    }
                }
                task.resume()
            }
            cityTextField.text = ""
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

