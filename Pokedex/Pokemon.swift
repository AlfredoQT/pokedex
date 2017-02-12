//
//  Pokemon.swift
//  Pokedex
//
//  Created by Alfredo Quintero Tlacuilo on 2/8/17.
//  Copyright © 2017 Alfredo Quintero Tlacuilo. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil{
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(self._pokemonURL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, Any> {
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    var typesStr = ""
                    for type in types {
                        if let name = type["name"] {
                            typesStr += "\(name.capitalized)/"
                        }
                    }
                    typesStr.remove(at: typesStr.index(before: typesStr.endIndex))
                    self._type = typesStr
                }
                else {
                    self._type = ""
                }
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>], descArray.count > 0 {
                    if let url = descArray[0]["resource_uri"] {
                        let descURL = "\(BASE_URL)\(url)"
                        Alamofire.request(descURL).responseJSON { response in
                            let resultDesc = response.result
                            if let dictDesc = resultDesc.value as? Dictionary<String, Any> {
                                if let description = dictDesc["description"] as? String {
                                    self._description = description
                                }
                            }
                            completed()
                        }
                    }
                }
                else {
                    self._description = ""
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String,Any>], evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        //Make sure that the evolution does not contain a name of mega
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                var newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                newStr.remove(at: newStr.index(before: newStr.endIndex))
                                self._nextEvolutionID = newStr
                            }
                            if let level = evolutions[0]["level"] as? Int {
                                self._nextEvolutionLevel = "\(level)"
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
}
