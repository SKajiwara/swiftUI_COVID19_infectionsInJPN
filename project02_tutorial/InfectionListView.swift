//
//  InfectionListView.swift
//  project02_infection
//
//  Created by Shinnosuke Kajiwara on 6/8/20.
//  Copyright © 2020 Shinnosuke Kajiwara. All rights reserved.
//

import SwiftUI
import Combine
 
struct InfectionListView: View {
    @ObservedObject private var viewModel = InfectionListViewModel()
    
    @State private var showFavoriteOnly = false
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle(isOn: $showFavoriteOnly) {
                    Text("ブックマークした県のみ表示")
                }.padding(.horizontal, 30)
                List(viewModel.infectionViewModels, id: \.self) { infectionViewModel in
                    Text(infectionViewModel.region + " - " + infectionViewModel.formattedInfectedCount)
                }.onAppear {
                        self.viewModel.fetchInfections()
                }
            }.navigationBarTitle("COVID19 Infections")
            
        }
        
    }
}

class InfectionListViewModel: ObservableObject {
    private let infectionApiService = InfectionApiService()
    
    @Published var infectionViewModels = [InfectionViewModel]()
    
    var cancellable: AnyCancellable?
    
    func fetchInfections() {
        cancellable = infectionApiService.fetchInfections().sink(receiveCompletion: { _ in
        }, receiveValue: { InfectionDataContainer in
            self.infectionViewModels = InfectionDataContainer.infectedByRegion.map { InfectionViewModel($0) }
            // MARK: print(self.infectionViewModels) // フェッチしたデータをConsoleで見たい時
        })
    }
}
 
struct InfectionViewModel: Hashable {
    private var infection: Infection
    
    var region: String {

        return infection.region
    }
    var formattedInfectedCount: String {
        // Int -> String のフォーマティング
        return String(infection.infectedCount)
    }
   
    init(_ infection: Infection) {
        self.infection = infection
    }
}

// MARK: プレビュ-
struct InfectionListView_Previews: PreviewProvider {
    static var previews: some View {
        InfectionListView()
    }
}
