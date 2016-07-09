//
//  Environment.swift
//  HybridAlgorithm
//
//  Created by zdaecqze zdaecq on 22.05.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

import Foundation


class Environment {
    
    // MARK: - Properties
    var pheromonesArray : [[Float]] = []
    var geneticsArray : [[Float]] = []
    var pheromoneDecreaseValue : Float = 0.1
    
    private var geneticsStartValue : Float = 0
    var pheromoneIncreaseValue : Float = 1
    
    
    // MARK: - Life cycle
    init(pheromonesValue: Float, citiesCount: Int, geneticsStartValue: Float) {
        pheromonesArray = Array(count: citiesCount, repeatedValue: Array(count: citiesCount, repeatedValue: pheromonesValue))
        geneticsArray = Array(count: citiesCount, repeatedValue: Array(count: citiesCount, repeatedValue: geneticsStartValue))
        self.geneticsStartValue = geneticsStartValue
    }
    
    
    // MARK: - Methods
    func updatePheromonesWithChromosomes(chromosoms: [Chromosome]) {
        
        let numberOfCities = chromosoms.first!.gensArray.count - 1
        
        // pheromone evaporation
        for i in 0...numberOfCities {
            for j in (i+1).stride(to: numberOfCities + 1, by: 1) {
                pheromonesArray[i][j] = (1 - pheromoneDecreaseValue) * pheromonesArray[i][j]
                pheromonesArray[j][i] = pheromonesArray[i][j]
            }
        }
        
        // update with chromosomes
        for i in 0..<chromosoms.count {
            
            let chrom = chromosoms[i]
            
            for j in 0...numberOfCities {
                
                let indexJ = (j == numberOfCities) ? 0 : j+1
                
                let city1 = chrom.gensArray[j]
                let city2 = chrom.gensArray[indexJ]
                
                let delta = pheromoneIncreaseValue / chrom.fitness
                
                pheromonesArray[city1][city2] += delta
                pheromonesArray[city2][city1] += delta
            }
        }
    }
    
    func updateGeneticsWithChromosomes(chromosoms: [Chromosome]) {
        
        let numberOfCities = chromosoms.first!.gensArray.count - 1
        
        geneticsArray = Array(count: numberOfCities + 1, repeatedValue: Array(count: numberOfCities + 1, repeatedValue: geneticsStartValue))
        
        // update with chromosomes
        for i in 0..<chromosoms.count {
            
            let chrom = chromosoms[i]
            
            for j in 0...numberOfCities {
                
                let indexJ = (j == numberOfCities) ? 0 : j+1
                
                let city1 = chrom.gensArray[j]
                let city2 = chrom.gensArray[indexJ]
                
                let delta = pheromoneIncreaseValue / chrom.fitness
                
                geneticsArray[city1][city2] += delta
                geneticsArray[city2][city1] += delta
            }
        }
    }
    
}