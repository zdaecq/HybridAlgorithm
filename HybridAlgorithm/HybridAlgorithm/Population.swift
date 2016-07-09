//
//  Population.swift
//  HybridAlgorithm
//
//  Created by zdaecqze zdaecq on 21.05.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

import UIKit

class Population {
    
    // MARK: - Properties
    var chromosomesArray : [Chromosome] = []
    
    
    // MARK: - Life cycle
    init(number: Int, lengthsArray: [[Float]]) {
        generateRandomСhromosomesWithNumber(number, andlengthsArray: lengthsArray)
    }
    
    
    // MARK: - Methods
    func layersForBestСhromosomeFor(citiesArray: [CGPoint]) -> [CALayer] {
        sort()
        return chromosomesArray.first!.makeLayersFromGensFor(citiesArray)
    }
    
    func printMe() {
        for chrom in chromosomesArray {
            chrom.printMe()
        }
    }
    
    
    // MARK: - Helpers
    func generateRandomСhromosomesWithNumber(number:Int, andlengthsArray array: [[Float]]) {
        for _ in 1...number {
            let newChromosome = Chromosome.createRandomChromosomeWithLengthsArray(array)
            chromosomesArray.append(newChromosome)
        }
    }
    
    func sort() {
        chromosomesArray.sortInPlace({ $0.fitness < $1.fitness })
    }
}

