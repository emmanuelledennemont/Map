//
//  CarteView.swift
//  MapKit2
//
//  Created by Cristina Casañas on 19/6/24.
//

import SwiftUI
import MapKit

struct CarteView: View {
    @State private var showSheet: Bool = false
    @State private var text: String = ""
    @State private var isEditing: Bool = false
    @State private var selectedOption = "Recycler" // Option par défaut
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            if #available(iOS 17, *) {
                Map(initialPosition: .region(.paris)) // Utilisation de la région de Paris
            } else {
                Map(coordinateRegion: .constant(.paris)) // Utilisation de la région de Paris
            }
            
            TabBar()
                .frame(height: 49)
                .background(.regularMaterial)
        }
        .task {
            showSheet = true // Déclenche l'affichage de la feuille lorsque cette vue est chargée
        }
        .accentColor(.orange) // Change la couleur d'accentuation de l'interface utilisateur pour l'onglet actuellement sélectionné
        .sheet(isPresented: $showSheet) {
            VStack(alignment: .center, spacing: 20) {
                Spacer().frame(height: 20) // Ajout de 20 points de padding au-dessus de la barre de recherche et de l'icône de filtre
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        TextField("Search ...", text: $text)
                            .padding(7)
                            .padding(.horizontal, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                            .onTapGesture {
                                self.isEditing = true
                            }
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                                self.isEditing = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    
                    Button(action: {
                        // Action du bouton filtre
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 10){
                    Picker(selection: $selectedOption, label: Text("")) {
                        Text("Recycler").tag("Recycler")
                        Text("Réparer").tag("Réparer")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200) // Ajustez la largeur selon vos besoins
            
                    .padding(.leading, 8) // Ajoutez un padding à gauche pour l'espacement
                    Spacer()                }
               
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.height(54), .medium, .large]) // Définit les points d'arrêt de la présentation de la feuille
            .presentationCornerRadius(20) // Définit le rayon de coin de la présentation de la feuille
            .presentationBackground(.regularMaterial) // Définit le fond de la présentation de la feuille
            .presentationBackgroundInteraction(.enabled(upThrough: .large)) // Active l'interaction avec le fond de la présentation de la feuille jusqu'à une taille large
            .interactiveDismissDisabled() // Désactive le renvoi interactif de la feuille
            .bottomMaskForSheet() // Applique un masque en bas de la vue
        }
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            TabView {
                // Boucle à travers tous les cas de l'énumération Tab
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    // Affiche le texte correspondant au cas de l'énumération
                    Text(tab.rawValue)
                        .tag(tab) // Utilise le cas de l'énumération comme tag
                    tab.view
                        .tabItem {
                            // Configure l'élément d'onglet avec une image et un texte
                       
                            Image(systemName: tab.symbol)
                            Text(tab.rawValue)
                        }
                        .toolbarBackground(.visible, for: .tabBar) // Définit un fond de barre d'outils visible
                }
            }
        }
    }
}

struct CarteView_Previews: PreviewProvider {
    static var previews: some View {
        CarteView()
    }
}

extension MKCoordinateRegion {
    static var paris: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522) // Coordonnées de Paris (latitude et longitude)
        return .init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000) // Rayon défini à 10 km autour du centre
    }
}
