//
//  Tab.swift
//  MapKit2
//
//  Created by Emmanuelle  Dennemont on 18/06/2024.
//

import SwiftUI

// Définition de l'énumération Tab avec des cas spécifiques
enum Tab: String, CaseIterable {
    case carte = "Carte" // Cas pour l'onglet "Carte"
    case calendrier = "Calendrier" // Cas pour l'onglet "Calendrier"
    case reparations = "Réparation" // Cas pour l'onglet "Réparation"
    case profil = "Profil" // Cas pour l'onglet "Profil"
    
    // Propriété calculée qui retourne le symbole SF Symbol correspondant à chaque cas
    var symbol: String {
        switch self {
        case .carte:
            return "map.fill" // Symbole pour l'onglet "Carte"
        case .calendrier:
            return "calendar" // Symbole pour l'onglet "Calendrier"
        case .reparations:
            return "wrench.adjustable.fill" // Symbole pour l'onglet "Réparation"
        case .profil:
            return "person.fill" // Symbole pour l'onglet "Profil"
        }
    }
}


