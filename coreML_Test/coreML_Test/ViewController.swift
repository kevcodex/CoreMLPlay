//
//  ViewController.swift
//  coreML_Test
//
//  Created by Kirby on 9/8/18.
//  Copyright © 2018 Kirby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let adLayer = AdvertisingLayer()
        let input = AdvertisingLayer.Input(dailyTimeSpent: 30, age: 20, income: 70000, dailyInternetUsage: 200, isMale: false)
        do {
            let output = try adLayer.prediction(input: input)
            print(output.willClickOnAd)
            print(output.probabilities)
        } catch {
            print(error)
        }
    }
}


struct AdvertisingLayer {
    private let model = Advertising()
    
    func prediction(dailyTimeSpent: Double, age: Double, income: Double, dailyInternetUsage: Double, isMale: Bool) throws -> Output {
        let maleAsDouble: Double = isMale ? 1 : 0
        let prediction = try model.prediction(Daily_Time_Spent_on_Site: dailyTimeSpent, Age: age, Area_Income: income, Daily_Internet_Usage: dailyInternetUsage, Male: maleAsDouble)
        
        let willClickOnAd = prediction.Clicked_on_Ad == 1 ? true : false
        let output = Output(willClickOnAd: willClickOnAd, probabilities: prediction.classProbability)
        return output
    }
    
    func prediction(input: Input) throws -> Output {
        let maleAsDouble: Double = input.isMale ? 1 : 0
        let prediction = try model.prediction(Daily_Time_Spent_on_Site: input.dailyTimeSpent, Age: input.age, Area_Income: input.income, Daily_Internet_Usage: input.dailyInternetUsage, Male: maleAsDouble)
        
        let willClickOnAd = prediction.Clicked_on_Ad == 1 ? true : false
        let output = Output(willClickOnAd: willClickOnAd, probabilities: prediction.classProbability)
        return output
    }
    
    func predictions(inputs: [Input]) throws -> [Bool] {
        
        var outputs: [Bool] = []
        for input in inputs {
            let maleAsDouble: Double = input.isMale ? 1 : 0
            let output = try model.prediction(Daily_Time_Spent_on_Site: input.dailyTimeSpent, Age: input.age, Area_Income: input.income, Daily_Internet_Usage: input.dailyInternetUsage, Male: maleAsDouble)
            
            let willClickAd = output.Clicked_on_Ad == 1 ? true : false
            outputs.append(willClickAd)
        }
        
        return outputs
    }
    
    struct Input {
        let dailyTimeSpent: Double
        let age: Double
        let income: Double
        let dailyInternetUsage: Double
        let isMale: Bool
    }
    
    struct Output {
        let willClickOnAd: Bool
        let probabilities: [Bool: Double]
        
        init(willClickOnAd: Bool, probabilities: [Int64: Double]) {
            self.willClickOnAd = willClickOnAd
            
            self.probabilities = probabilities.reduce(into: [Bool: Double](), { (result, dict) in
                let newKey = dict.key == 1 ? true : false
                result[newKey] = dict.value
            })
        }
    }
}
