//
//  Chromosome.swift
//  HybridAlgorithm
//
//  Created by zdaecqze zdaecq on 21.05.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

import UIKit

// TODO: remove WithLengthsArray in every method by adding property
class Chromosome {
    
    // MARK: - Properties
    var gensArray : [Int] = []
    var fitness : Float = 0
    

    // MARK: - Methods
    func printMe() {
        
        var str = ""
        for i in gensArray {
            str += "\(i) "
        }
        
        print("fitness: \(fitness), gens: " + str)
    }
    
    func makeLayersFromGensFor(citiesArray: [CGPoint]) -> [CALayer] {
        
        //get cities points from chromosome gens
        var chromosomeCitiesPointArray : [CGPoint] = []
        
        for i in gensArray {
            chromosomeCitiesPointArray.append(citiesArray[i])
        }

        let chromosomeCitiesPointArrayCount = chromosomeCitiesPointArray.count-1
        
        //init
        var j = 0
        var cityBase = CGPoint()
        var cityNext = CGPoint()
        
        let path = UIBezierPath()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.purpleColor().CGColor
        shapeLayer.lineWidth = 2
        var shapeLayerArray : [CALayer] = []
        
        //drawing lines between cities
        for i in 0...chromosomeCitiesPointArrayCount {
            
            j = (i == chromosomeCitiesPointArrayCount) ? 0 : i+1
            
            cityBase = chromosomeCitiesPointArray[i]
            cityNext = chromosomeCitiesPointArray[j]
            
            path.moveToPoint(cityBase)
            path.addLineToPoint(cityNext)
            
            shapeLayer.path = path.CGPath

            shapeLayerArray.append(shapeLayer)
        }
        
        return shapeLayerArray
    }
    
    func getNewMutatedChromosomeWithLengthsArray(array: [[Float]]) -> Chromosome {
        
        let newChromosome = Chromosome()
        newChromosome.gensArray = gensArray
        
        let randIndex1 = Int(arc4random_uniform(UInt32(gensArray.count)))
        let randIndex2 = Int(arc4random_uniform(UInt32(gensArray.count)))
        let randIndex3 = Int(arc4random_uniform(UInt32(gensArray.count)))
        
        if randIndex2 != randIndex3 {
            swap(&newChromosome.gensArray[randIndex2], &newChromosome.gensArray[randIndex3])
        }
        
        if randIndex1 != randIndex2 {
            swap(&newChromosome.gensArray[randIndex1], &newChromosome.gensArray[randIndex2])
        }
        
        newChromosome.countFitnessWithLengthsArray(array)
        
        return newChromosome
    }
    
    
    func updateGensWithLengthsArray(array: [[Float]], environment: Environment, alpha: Float, betta: Float, gamma: Float) {
        
        var newGensArray : [Int] = []
        newGensArray.append(gensArray.first!)
        gensArray.removeFirst()
        
        let numberOfCities = gensArray.count - 1
        
        var probabilitiesGoToCityArray : [Float] = []
        var sum : Float = 0
        var city1 = 0
        var city2 = 0
        var lengthBetweenCities : Float = 0
        var current : Float = 0
        var probArrayCount = 0
        
        for i in 0...numberOfCities - 1 { // -1 bcz last gen put without probabilities
            
            probabilitiesGoToCityArray = []
            sum = 0
            
            //--------- count probabilities for next gen
            for j in 0..<gensArray.count {
                
                city1 = newGensArray[i]
                city2 = gensArray[j]
                
                lengthBetweenCities = array[city1][city2]
                current = powf(environment.pheromonesArray[city1][city2], alpha) * powf(1.0 / lengthBetweenCities, betta) * powf(environment.geneticsArray[city1][city2], gamma)
                
                sum += current
                
                probabilitiesGoToCityArray.append(current * 100) //*100 bcz will be 100% in sum
                
            }
            
            probArrayCount = probabilitiesGoToCityArray.count
            
            // divide the numerator by the denominator of the formula
            for j in 0..<probArrayCount {
                probabilitiesGoToCityArray[j] = probabilitiesGoToCityArray[j] / sum
            }
            //--------- now we got all probabilities
            
            for j in 1..<probArrayCount {
                probabilitiesGoToCityArray[j] += probabilitiesGoToCityArray[j-1]
            }
            
            // choose next gen on probability and add it
            let randomNumber = Float(arc4random_uniform(100))
            
            for j in 0..<probArrayCount {
                if randomNumber < probabilitiesGoToCityArray[j] {
                    newGensArray.append(gensArray[j])
                    gensArray.removeAtIndex(j)
                    break
                }
            }
        }
        
        newGensArray.append(gensArray[0])
        gensArray = newGensArray
        countFitnessWithLengthsArray(array)
    }
    
    
    // MARK: - Class functions
    static func createRandomChromosomeWithLengthsArray(array: [[Float]]) -> Chromosome {
        let newChromosome = Chromosome()
        newChromosome.generateRandomGensWithSize(array.count)
        newChromosome.countFitnessWithLengthsArray(array)
        return newChromosome
    }
    
    /*
    Даны две родительские хромосомы S, T и точка разреза хромосом k. Дочерние хромосомы будут формироваться следующим образом: выбирается ген si , (i=1, ..., k) хромосомы S, находящийся в пределах зоны кроссинговера (1, ..., k) и меняется местами с геном sj = ti. Процесс продолжается, пока не будет достигнут ген sk
    */
    static func crossingover(chromosome1 chromosome1: Chromosome, chromosome2: Chromosome, array: [[Float]]) -> Chromosome {
        let newChromosome = Chromosome()
        
        let gensCount = chromosome1.gensArray.count
        let splitIndex = gensCount / 2 - 1
        var isFound = false
        
        var chrom1GensArray = chromosome1.gensArray
        var chrom2GensArray = chromosome2.gensArray
        
        for i in 0...splitIndex {
            
            let ti = chrom2GensArray[i]
            
            for j in splitIndex+1...gensCount-1 {
                
                if ti == chrom1GensArray[j] {
                    swap(&chrom1GensArray[i], &chrom1GensArray[j])
                    newChromosome.gensArray.append(ti)
                    isFound = true
                    break
                }
            }
            
            if !isFound {
                newChromosome.gensArray.append(chrom1GensArray[i])
            } else {
                isFound = false
            }
        }
        
        for j in splitIndex+1...gensCount-1 {
            newChromosome.gensArray.append(chrom1GensArray[j])
        }
        
        newChromosome.countFitnessWithLengthsArray(array)
        return newChromosome
    }
    
    
    // MARK: - Private functions
    private func generateRandomGensWithSize(size: Int) {
        var newGens : [Int] = []
        
        for i in 0...size-1 {
            newGens.append(i)
        }
        
        newGens.shuffleInPlace()
        gensArray = newGens
    }
    
    private func countFitnessWithLengthsArray(array: [[Float]]) {
        
        var result = 0 as Float
        let gensNumber = gensArray.count - 1
        var j = 0
        var city1 = 0
        var city2 = 0
        
        for i in 0...gensNumber {
            
            j = (i == gensNumber) ? 0 : i+1
            
            city1 = gensArray[i]
            city2 = gensArray[j]
            
            result += array[city1][city2]
        }
        
        fitness = result
    }
}





