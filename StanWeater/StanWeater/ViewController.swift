//
//  ViewController.swift
//  StanWeater
//
//  Created by Stan on 2023/3/27.
//
//API https://weatherstack.com
//API documentation https://weatherstack.com/documentation
//Note that if any API error is reported, it is because you did not pay for the subscription

import UIKit

class ViewController: UIViewController,UITableViewDataSource {

    
    static let host = "http://api.weatherstack.com/current?access_key=3d646eb9ff999ffc28f654b7ec6eb4c4&query=";
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.view.addSubview(self.tableView)

        let citys = ["Beijing","Shanghai","Guangzhou","Shenzhen","Suzhou"]
        citys.forEach { city in
            getWeather(city: city)
        }
        
    }

    //GET weater
    func getWeather(city:String) -> Void {
        guard let url = URL(string: ViewController.host+city) else { return }
        let request = URLRequest.init(url: url )
        
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            let dictionary = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            if let jsonResult = dictionary as? Dictionary<String, AnyObject> {
                
                print(jsonResult)
                
                let weather = jsonResult["current"]?["weather_descriptions"];
                let city = jsonResult["location"]?["name"];
                
                
                
                let model = Model()
                
                if city != nil{
                    let city = city as!String
                    model.city = city
                }
                
                if weather != nil{
                    let weather = (weather as!NSMutableArray).firstObject as!String
                    model.weater = weather
                }
               
                self.arry.append(model)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            }
        }
        task.resume()
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
    
        let model = self.arry[indexPath.row]
        cell?.textLabel?.text = model.city
        cell?.detailTextLabel?.text = model.weater
        
        return cell ?? UITableViewCell()
    }
    
    
    
    //GET
    lazy var arry: Array<Model> = {
        arry = Array()
        return arry
    }()
    lazy var tableView: UITableView = {
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        tableView.dataSource = self
        return tableView
    }()
    
   
    
    
}

