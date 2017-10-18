//
//  ViewController.swift
//  ProgrammingCollegeApp
//
//  Created by Bram Honingh on 17-10-17.
//  Copyright © 2017 DigitalCoder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherTypeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    let apiUrlString = "https://api.apixu.com/v1/current.json?key=4226f9d175c4474f987124026171010&q=amsterdam"
    
    struct Weather: Decodable {
        let location: Location
        let current: Current
    }
    
    struct Location: Decodable {
        let name: String
        let country: String
    }
    
    struct Current: Decodable {
        let temp_c: Double
        let wind_kph: Double
        let wind_dir: String
        let feelslike_c: Double
        let condition: Condition
    }
    
    struct Condition: Decodable {
        let text: String
        let icon: String
    }
    
    func getWeatherImage(urlString: String) {
        let httpsUrlString: String = "https:" + urlString
        let url = URL(string: httpsUrlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else { return }
            
            print(data)
            
            DispatchQueue.main.async {
                self.weatherImage.image = UIImage(data: data)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: apiUrlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                let currentWeather = try JSONDecoder().decode(Weather.self, from: data)
                
                print(currentWeather.current.condition.text)
                
                DispatchQueue.main.async {
                    let location: String = currentWeather.location.name + ", " + currentWeather.location.country
                    let temperature: String = String(currentWeather.current.temp_c) + "°"
                    
                    print(currentWeather.current.condition.icon)
                    
                    self.weatherTypeLabel.text = currentWeather.current.condition.text
                    self.locationLabel.text = location
                    self.temperatureLabel.text = temperature
                    let httpsUrlString: String = "https:" + currentWeather.current.condition.icon
                    
                    guard let url = URL(string: httpsUrlString) else { return }
                    guard let data = try? Data(contentsOf: url) else { return }
                    self.weatherImage.image = UIImage(data: data)
                    
                }
                
                
            } catch {
                
            }
            
            
            }.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

