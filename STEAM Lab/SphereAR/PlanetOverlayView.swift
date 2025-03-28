//
//  Planet Overlay.swift
//  SphereAR
//
//  Created by uczen on 27/03/2025.
//

import SwiftUI

struct PlanetOverlayView: View {
    @State var planet: PlanetInformation
    @State private var show: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top){
                Text(planet.name)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
            }
            .padding()
            Divider()
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    Text("Opis:")
                        .font(.title2)
                        .bold()
                    ScrollView{
                        Text(planet.description)
                            .font(.title3)
                    }
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .center){
                    Text("Promień")
                        .font(.title2)
                        .bold()
                    Group{
                        Text(planet.radius)
                            .font(.title2)
                    }
                    Spacer()
                    Text("Masa")
                        .font(.title2)
                        .bold()
                    Text(planet.mass)
                        .font(.title2)
                    Spacer()

                }
                .padding()
            }
        }
        .frame(height: 300)
        .background(.thinMaterial)
        .tint(.red)
        .cornerRadius(10)
        .animation(Animation.easeInOut(duration: 0.4),value: show)
        .onAppear{
            show = true
        }
        .onDisappear{
            show = false
        }
    }
}

#Preview {
    PlanetOverlayView(planet: PlanetInformation(
        name:"Sun",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras pretium sagittis maximus. Phasellus sit amet pulvinar turpis. Quisque condimentum quis libero et vulputate. Curabitur interdum lacus sit amet mauris porttitor, in finibus libero sagittis. Nam neque est, mollis at ante sed, mattis sollicitudin ex. Cras nec ante quis diam faucibus pretium. Phasellus pellentesque sagittis semper. Quisque auctor orci porttitor ex dignissim, ut lobortis libero suscipit. Aliquam aliquam, neque quis tincidunt pulvinar, diam justo tempor urna, ut suscipit ex turpis id elit. Ut aliquam vitae est quis viverra. Proin enim eros, pretium id maximus at, lacinia id massa. Cras maximus neque eros, ac cursus enim consequat vehicula. Sed purus tellus, auctor id purus eu, dictum rhoncus tellus. Vivamus ut sem congue arcu rhoncus suscipit.",
        radius: "20",
        mass:"10"
    ))
}
