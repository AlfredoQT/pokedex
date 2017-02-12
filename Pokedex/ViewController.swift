//
//  ViewController.swift
//  Pokedex
//
//  Created by Alfredo Quintero Tlacuilo on 2/8/17.
//  Copyright © 2017 Alfredo Quintero Tlacuilo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    var musicPlayer: AVAudioPlayer!
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            //Will play continuously
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collection.dataSource = self
        collection.delegate = self
        parsePokemonCSV()
        initAudio()
        searchBar.delegate = self
        //We don't want it to say search again since it's redundant
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
        }
        catch{
            let error = error as NSError
            print("\(error.debugDescription)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            let pokemon: Pokemon!
            if inSearchMode {
                pokemon = self.filteredPokemon[indexPath.row]
            }
            else{
                pokemon = self.pokemon[indexPath.row]
            }
            cell.configureCell(pokemon)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemon: Pokemon!
        if inSearchMode {
            pokemon = filteredPokemon[indexPath.row]
        }
        else {
            pokemon = self.pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailsVC", sender: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        }
        else{
            return pokemon.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnClicked(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        }
        else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hide keyboard
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            //Hide keyboard
            view.endEditing(true)
        }
        else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            //The filteredPokemon list is going to be equal to the pokemon list filtered
            //$0 is gonna be a placeholder to each Pokemon, name is an attribute of that placeholder as it is a Pokemon
            //range(of: lower) is going to check if lower is contained in the name of each Pokemon in the list
            //filteredPokemon is assigned a filtered version of pokemon based on whether the text of the search bar is in the range of the name of the Pokemon
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailsVC" {
            if let destination = segue.destination as? PokemonDetailsVC {
                if let poke = sender as? Pokemon {
                    destination.pokemon = poke
                }
            }
        }
    }
    
}

