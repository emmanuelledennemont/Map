//
//  ButtonShettHelpers.swift
//  MapKit2
//
//  Created by Emmanuelle  Dennemont on 18/06/2024.
//
import SwiftUI


// Extension pour ajouter une fonction de masquage inférieur à une vue
extension View {
    @ViewBuilder
    func bottomMaskForSheet(_ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(height: height)) // Applique le SheetRootViewFinder en arrière-plan
    }
}

// Struct UIViewRepresentable pour manipuler la vue sous-jacente
fileprivate struct SheetRootViewFinder: UIViewRepresentable {
    var height: CGFloat // Hauteur à réduire de la vue
    
    // Crée un coordinateur pour gérer les interactions avec UIKit
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    // Crée une nouvelle instance de UIView
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    // Met à jour la vue UIView
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard !context.coordinator.isMasked else { return } // Vérifie si le masquage est déjà appliqué
            
            // Recherche la vue racine avant la fenêtre
            if let rootView = uiView.viewBeforeWindow {
                let safeArea = rootView.safeAreaInsets // Zones de sécurité de la vue racine
                
                // Redimensionne la vue racine pour masquer une partie inférieure
                rootView.frame = CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: rootView.frame.width,
                        height: rootView.frame.height - (height + safeArea.bottom)
                    )
                )
                rootView.clipsToBounds = true // Coupe les débordements de contenu
                
                // Parcourt toutes les sous-vues de la vue racine
                for view in rootView.subviews {
                    view.layer.shadowColor = UIColor.clear.cgColor // Supprime l'ombre
                    
                    // Vérifie si une animation de coin est en cours
                    if view.layer.animationKeys() != nil {
                        // Recherche une vue avec une animation de coin
                        if let cornerRadiusView = view.allSubViews.first(where: {
                            $0.layer.animationKeys()?.contains("cornerRadius") ?? false
                        }) {
                            cornerRadiusView.layer.maskedCorners = [] // Supprime les coins masqués
                        }
                    }
                }
                
                context.coordinator.isMasked = true // Indique que le masquage est appliqué
            }
        }
    }
    
    // Classe pour gérer les interactions avec UIKit
    class Coordinator: NSObject {
        var isMasked: Bool = false // Indicateur pour le statut du masquage
    }
}

// Extension privée pour UIView
fileprivate extension UIView {
    // Retourne la vue avant la fenêtre, si elle existe
    var viewBeforeWindow: UIView? {
        if let superview = superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }
    
    // Retourne toutes les sous-vues de la vue actuelle, récursivement
    var allSubViews: [UIView] {
        return subviews.flatMap { [$0] + $0.allSubViews }
    }
}

#Preview {
    ContentView()
}
