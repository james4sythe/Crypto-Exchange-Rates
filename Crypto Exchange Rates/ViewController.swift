//
//  ViewController.swift
//  Crypto Exchange Rates
//
//  Created by James Forsythe on 8/20/18.
//  Copyright © 2018 James Forsythe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://min-api.cryptocompare.com/data/price?fsym="
    let addURL = "&tsyms="
    let cryptoArray = ["","ADA","BCH","BTC","EOS","ETH","LTC","USDT","XLM","XRP","ZEC"]
    let currencyArray = ["","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["","$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var selectedCrypto = ""
    var selectedCryptoSymbol = ""
    var selectedCurrency = ""
    var selectedCurrencySymbol = ""


    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var valuePicker: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valuePicker.delegate = self
        valuePicker.dataSource = self
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cryptoArray.count
        } else if component == 1 {
            return 1
        } else {
            return currencyArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return cryptoArray[row]
        } else if component == 1{
            return "TO"
        } else {
            return currencyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedCrypto = cryptoArray[row]
            cryptoImage.image = UIImage(named: selectedCrypto)
        }
        if component == 2 {
            selectedCurrency = currencyArray[row]
            selectedCurrencySymbol = currencySymbolArray[row]
        }
        finalURL = baseURL + selectedCrypto + addURL + selectedCurrency
        getExchangeRates(url: finalURL)

    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getExchangeRates(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Success! Got the exchange rate")
                    let currentJSON : JSON = JSON(response.result.value!)
                    self.updateExchangeRate(json: currentJSON)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.priceLabel.text = "Connection Issues"
                }
        }
        
    }
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateExchangeRate(json : JSON) {
        
        if let exchangeResult = json["\(selectedCurrency)"].double {
            priceLabel.text = ("\(selectedCurrencySymbol)\(exchangeResult)")
            
        } else {
            priceLabel.text = "Price Unavailable"
        }
    }

}

