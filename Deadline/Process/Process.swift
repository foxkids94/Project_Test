//
//  Process.swift
//  Deadline
//
//  Created by Юрий Макаров on 21/11/2018.
//  Copyright © 2018 Юрий Макаров. All rights reserved.
//

import Foundation
import Alamofire

class DataProvider { //Хранлка основных настроект
    static let shared = DataProvider()
    let baseUrl: URL = URL(string: "https://revolut.duckdns.org/latest?base=")!
    var startMoney = "EUR"
    var fullUrl: URL {
        return URL(string: "\(baseUrl)\(startMoney)")!
    }
    private init() {}
    var allMoney: [Money] = []
   
}


protocol Publish: class {
    func add(listener: Listener)
    func sendData(send: Money)
}

protocol Listener {
    func update(money: Money)
}

protocol ProcessDelegate {
    func Initialization()
}

class Process: Publish {
    
    var delegate: ProcessDelegate?
    private var allListener: [Listener] = []
    
    
    func add(listener: Listener) {
        self.allListener.append(listener)
    }
    
    func sendData(send: Money) {
        for i in allListener {
            (i as? Listener)?.update(money: send)
        }
    }
    
    func Download() {
        request(DataProvider.shared.fullUrl).responseJSON { (response) in
            if let valueData = response.result.value as? [String : Any] {
                if let allMoney = valueData["rates"] as? [String : Double] {
                    for (index, value) in allMoney.enumerated() {
                        let newMoney = Money(index: index, title: value.key, value: value.value)
                        if self.resultBool(money: newMoney) {
                        DataProvider.shared.allMoney.append(newMoney)
                            self.delegate?.Initialization()
                        } else {
                            self.sendData(send: newMoney)
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    func resultBool(money: Money) -> Bool {
        var result: Bool = true
        
        for i in DataProvider.shared.allMoney {
            if i.title == money.title {
                result = false
            }
        }
        return result
    }
    
    
    
}


struct Money {
    let index: Int
    let title: String
    var value: Double
}
