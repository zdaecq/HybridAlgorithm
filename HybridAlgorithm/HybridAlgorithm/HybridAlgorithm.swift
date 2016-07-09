//
//  HybridAlgorithm.swift
//  HybridAlgorithm
//
//  Created by zdaecqze zdaecq on 09.07.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

import UIKit


class HybridAlgorithm {
    
    // MARK: - Properties
    var citiesArray : [CGPoint] = []
    var controller : UIViewController?
    
    private var lengthBetweenCitiesArray : [[Float]] = []
    private var resultLayers : [CALayer] = []
    
    // MARK: - Life cycle
    //init (controller: UIViewController) {
        //self.controller = controller
    //}
    
    
    // MARK: - Actions
    func start() {
        
        guard let controller = controller else {
            print("ERROR: you need add controller")
            return
        }
        
        if citiesArray.count < 3 {
            return
        }
        
        for layer in resultLayers {
            layer.removeFromSuperlayer()
        }
        
        countLengthBetweenCities()
        
        let populationLifeTime = citiesArray.count * 3
        let populationSize = citiesArray.count
        let pheromonesInitValue = 0.001 as Float
        let geneticsStartValue = 0.1 as Float
        let maxBestChromosomeCount = citiesArray.count
        
        let alpha = 1.0 as Float
        let betta = 1.0 as Float
        let gamma = 1.0 as Float
        
        var bestChromosome = 0 as Float
        var bestCount = 0
        let halfOfPopulation = populationSize / 2
        
        var chrom = Chromosome()
        var chrom1 = Chromosome()
        var chrom2 = Chromosome()
        
        let population = Population(number: populationSize, lengthsArray: lengthBetweenCitiesArray)
        let environment = Environment(pheromonesValue: pheromonesInitValue, citiesCount: citiesArray.count, geneticsStartValue: geneticsStartValue)
        
        for i in 0..<populationLifeTime {
            
            for chrom in population.chromosomesArray {
                chrom.updateGensWithLengthsArray(lengthBetweenCitiesArray, environment: environment, alpha: alpha, betta: betta, gamma: gamma)
            }
            
            environment.updatePheromonesWithChromosomes(population.chromosomesArray)
            environment.updateGeneticsWithChromosomes(population.chromosomesArray)
            
            population.sort()
            
            for i in 0..<halfOfPopulation {
                chrom = population.chromosomesArray[i].getNewMutatedChromosomeWithLengthsArray(lengthBetweenCitiesArray)
                population.chromosomesArray.append(chrom)
            }
            
            for i in 0..<halfOfPopulation {
                chrom1 = population.chromosomesArray[i]
                chrom2 = population.chromosomesArray[i + halfOfPopulation]
                chrom = Chromosome.crossingover(chromosome1: chrom1, chromosome2: chrom2, array: lengthBetweenCitiesArray)
                population.chromosomesArray.append(chrom)
            }
            
            population.sort()
            
            for _ in 0..<halfOfPopulation*2 {
                population.chromosomesArray.removeLast()
            }
            
            
            // condition for exit without changing best result
            if bestChromosome == population.chromosomesArray[0].fitness {
                bestCount += 1
            } else {
                bestChromosome = population.chromosomesArray[0].fitness
                bestCount = 0
            }
            
            if bestCount == maxBestChromosomeCount {
                print("Exit on \(i) iteration")
                break
            }
        }
        
        //result
        resultLayers = population.layersForBestСhromosomeFor(citiesArray)
        let bestChrom = population.chromosomesArray.first!
        var str = ""
        for i in bestChrom.gensArray {
            str += String(i) + " "
        }
        
        let alertController = UIAlertController(title: "Fitness \(bestChrom.fitness)", message: str, preferredStyle: .Alert)
        let okActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(okActon)
        controller.presentViewController(alertController, animated: true, completion: nil)
        
        for layer in resultLayers {
            controller.view.layer.addSublayer(layer)
        }
    }
    
    func clearResult() {
        
        guard let controller = controller else {
            print("ERROR: you need add controller")
            return
        }
        
        citiesArray.removeAll()
        
        if let sublayers = controller.view.layer.sublayers {
            for layer in sublayers {
                if layer.isKindOfClass(CAShapeLayer) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    
    // MARK: - Helpers
    private func countLengthBetweenCities() {
        
        var length = 0 as Float
        let numberOfCities = citiesArray.count
        lengthBetweenCitiesArray = Array(count: numberOfCities, repeatedValue: Array(count: numberOfCities, repeatedValue: 0))
        
        for i in 0...numberOfCities-1 {
            for j in (i+1).stride(to: numberOfCities, by: 1) {
                
                let city1 = citiesArray[i]
                let city2 = citiesArray[j]
                
                length = sqrt( pow(Float(city2.x - city1.x), 2) + pow(Float(city2.y - city1.y), 2) )
                
                lengthBetweenCitiesArray[i][j] = length
                lengthBetweenCitiesArray[j][i] = length
            }
        }
    }
}