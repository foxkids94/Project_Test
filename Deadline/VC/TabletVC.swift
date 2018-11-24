//
//  TabletVC.swift
//  Deadline
//
//  Created by Юрий Макаров on 21/11/2018.
//  Copyright © 2018 Юрий Макаров. All rights reserved.
//

import UIKit

class TabletVC: UITableViewController, Listener, ProcessDelegate {
    
    let process = Process()
    
    
    func Initialization() {
        self.tableView.reloadData()
    }
    
    func update(money: Money) {
        let index = IndexPath(row: money.index, section: 0)
        let cell = self.tableView.cellForRow(at: index) as? CellMoney
        cell?.title.text = money.title
        cell?.value.text = String(money.value)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        process.delegate = self
        process.add(listener: self)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.process.Download()
        }
    }

}



class CellMoney: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UITextField!
}



extension TabletVC {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataProvider.shared.allMoney.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellMoney
        
        cell!.title?.text = DataProvider.shared.allMoney[indexPath.row].title
        cell?.value.text =  String(DataProvider.shared.allMoney[indexPath.row].value)
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataProvider.shared.startMoney = DataProvider.shared.allMoney[indexPath.row].title
        alert(title: DataProvider.shared.allMoney[indexPath.row].title)
    }
    
    
    func alert(title: String) {
        let alertVC = UIAlertController(title: "Смена валюты", message: "Теперь эталонной валютой будет - \(title)", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertVC.addAction(actionOK)
        self.present(alertVC, animated: true, completion: nil)
    }
}
