//
//  ViewController.swift
//  BitcoinTicker
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    var selectCurrency = ""
    var emptyDict: [String: String] = [:]
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
    }
    func numberOfComponents(in pickView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) {
        selectCurrency = currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCurrency = currencyArray[row]
        makeGetCall()
    }
    
    func makeGetCall() {
        // Set up the URL request
        let todoEndpoint: String = baseURL + selectCurrency
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            
  
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }

                print("The todo is: " + todo.description)

                guard let lol = todo["bid"] else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                let str = String(describing: lol)
                DispatchQueue.main.async {
                    self.bitcoinPriceLabel.text = str
                    if let valor = (self.emptyDict[self.selectCurrency]) as? String {
                        if  Double(valor)! > Double(str)!{
                            let yourImage: UIImage = UIImage(named: "flechaRoja1")!
                            self.imagen.image = yourImage
                        }
                        else{
                            let yourImage: UIImage = UIImage(named: "flechaVerde1")!
                            self.imagen.image = yourImage
                        }
                    }
                self.emptyDict[self.selectCurrency] = str
                }
            } catch  {
                print("error trying to convert data to JSON")
                DispatchQueue.main.async {
                    self.bitcoinPriceLabel.text = "error"
                   
                }
                return
            }
        }
        task.resume()
    }
}
