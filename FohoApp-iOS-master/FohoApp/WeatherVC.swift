//
//  WeatherViewControler.swift
//  FohoApp
//
//  Created by AaronR on 1/6/17.
//  Copyright © 2017 Aaron Renfroe. All rights reserved.
//

import UIKit
import Foundation

class WeatherVC : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var weatherUpdateTime: Date?
    private var weeklyforecast: Array<WeatherItem>? = Array()
    
    @IBAction func backButton(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.30
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var weekTable: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var wLabel: UILabel! // Wind DataLabel
    @IBOutlet weak var fLabel: UILabel! // feels like DataLabel
    @IBOutlet weak var hLabel: UILabel! // humidity DataLabel
    @IBOutlet weak var copLabel: UILabel! // chance of precipitation DataLabel
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Monday, Tuesday etc.
        currentDay.text = MyDateTime.getDayOfWeek(date: Date())
        
        
        // Setting up Table
        weekTable.delegate = self  // Links table from Interface Builder to this class
        weekTable.dataSource = self // Links table from Interface Builder to this class
        weekTable.layer.masksToBounds = true // make pretty
        weekTable.layer.cornerRadius = 10 //make pretter
    
        processWeather()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Checks if weather is old and updates
        checkWeatherAge()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func weatherFetched(){
        processWeather()
        weatherUpdateTime = Date()
        let defaults = UserDefaults.standard
        defaults.set(self.weatherUpdateTime, forKey: "weatherUpdateTime")
    }
    
    func processWeather(){
        
        // Weather is stored in Userdefaults after being updated by the drawer
        let defaults = UserDefaults.standard
        
        guard let weatherDict = defaults.dictionary(forKey: "weatherForestFalls") else{
            // weather is not in defaults (which should never happen)
            checkWeatherAge()
            return
        }
        
        // Checkig if data is valid
        // if not function returns.
        guard let current = weatherDict["currently"] as? Dictionary<String, Any> else {return}
        guard let temp = current["temperature"] as? NSNumber else {return}
        guard let feelsLike = current["apparentTemperature"] as? NSNumber else {return}
        guard let percip = current["precipProbability"] as? NSNumber else {return}
        guard let weeklySummary = (weatherDict["daily"] as! Dictionary<String,Any>)["summary"] as? String else{ return }
        guard let humidity = current["humidity"] as? NSNumber else{return}
        guard let wind = current["windSpeed"] as? NSNumber else { return }
        
        // Not using
        //guard let icon = current["icon"] as? String else {return}
        //guard let summary = current["summary"] as? String else{return}
        //guard let time = current["time"] as? NSNumber else {return}
        
        
        // Current Temp
        currentLabel.text = ("\(temp.intValue)\u{00B0}")
        
        fLabel.text = "\(feelsLike.intValue)\u{00B0}"
        copLabel.text = "\(Int(percip.doubleValue * 100.0))%"
        hLabel.text = "\(Int(humidity.doubleValue * 100.0))%"
        wLabel.text = "\(round(wind.doubleValue * 10)/10) mph"
        
        summaryLabel.text = "\(weeklySummary)"
        
        weeklyforecast = dailyWeather(daily: (weatherDict["daily"] as! Dictionary<String,Any>)["data"] as! Array<Dictionary<String, Any>>)
        
        //Refresh the Table
        weekTable.reloadData()
        
    }
    
    // creats the table rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell") as! DayCell
        let day = weeklyforecast?[indexPath.row + 1]
        
        cell.dayLabel.text = MyDateTime.getDayOfWeek(date: Date(timeIntervalSince1970: TimeInterval(exactly: (day?.time)!)!))
        cell.lowTemp.text = "L: \(day!.tempMin)\u{00B0}"
        cell.highTemp.text = "H: \(day!.tempMax)\u{00B0}"
        cell.setIcon(icon: (day?.icon)!)
        return cell
        
    }
    
    // Returns how many rows will be in the table
    // We return the smaller number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(7, (weeklyforecast?.count)!)
    }
    
    // processing the json into a struct for each day and appends to an Array, sorts, and returns the array
    func dailyWeather(daily: Array<Dictionary<String, Any>>) -> Array<WeatherItem>{
        var tempDailyWeather = Array<WeatherItem>()
        
        for day in daily {
    
            guard let time = day["time"] as? NSNumber else { continue }
            guard let icon = day["icon"] as? String else { continue }
            guard let precipProb = day["precipProbability"] as? NSNumber else { continue }
            guard let disc = day["summary"] as? String else { continue }
            guard let tempMax = day["temperatureMax"] as? NSNumber else { continue }
            guard let tempMin = day["temperatureMin"] as? NSNumber else { continue }
            
            tempDailyWeather.append(WeatherItem(tempMin: tempMin.intValue, tempMax: tempMax.intValue,
                                                precipProb: (precipProb.doubleValue * 100.0), summary: disc, icon: icon, time: time.doubleValue))
        }
        tempDailyWeather.sort{
            $0.time < $1.time
        }
        
        return tempDailyWeather
    }
    
    // updates weather if older than two minutes
    func checkWeatherAge(){
        if let weatherUpdateTime = UserDefaults.standard.value(forKey: "weatherUpdateTime") as? Date{
            let ti:Double = weatherUpdateTime.timeIntervalSince(Date())
            print("********************\(ti)************")
            if ((ti) < -120.0){
                
                HTTPRequestManager2.getWeather(url: Settings.WEATHER_URL_FOREST_FALLS, campus: Campus.FOREST_FALLS){
                    // getWeatherIs a function and when it completes I'm telling it to call
                    // weatherFetched()
                    self.weatherFetched()
                }
            }
        }else{
            HTTPRequestManager2.getWeather(url: Settings.WEATHER_URL_FOREST_FALLS, campus: Campus.FOREST_FALLS){
                self.weatherFetched()
            }
        }
    }
    
}

struct WeatherItem{
    let tempMin : Int
    let tempMax : Int
    let precipProb: Double
    let summary: String
    let icon: String
    let time : Double
    
}
