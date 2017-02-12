//
//  PokemonDetailsVC.swift
//  Pokedex
//
//  Created by Alfredo Quintero Tlacuilo on 2/11/17.
//  Copyright © 2017 Alfredo Quintero Tlacuilo. All rights reserved.
//

import UIKit

class PokemonDetailsVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokeIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name.capitalized
        pokeIdLbl.text = "\(pokemon.pokedexId)"
        thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI(){
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.attack
        typeLbl.text = pokemon.type
    }
}
