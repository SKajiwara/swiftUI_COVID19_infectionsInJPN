//
//  InfectionListView.swift
//  project02_tutorial
//
//  Created by Shinnosuke Kajiwara on 6/8/20.
//  Copyright © 2020 Shinnosuke Kajiwara. All rights reserved.
//

import SwiftUI
import Combine
 
struct InfectionListView: View {
    @ObservedObject private var viewModel = TutorialListViewModel()
    var body: some View {
        List(viewModel.tutorialViewModels, id: \.self) { tutorialViewModel in
            Text(tutorialViewModel.region + " - " + tutorialViewModel.formattedInfectedCount)
        }.onAppear {
                self.viewModel.fetchTutorials()
        }
    }
}

class TutorialListViewModel: ObservableObject {
    
    private let tutorialApiService = TutorialApiService()
    @Published var tutorialViewModels = [TutorialViewModel]()
    
    var cancellable: AnyCancellable?
    
    func fetchTutorials() {
        cancellable = tutorialApiService.fetchTutorials().sink(receiveCompletion: { _ in
            
        }, receiveValue: { TutorialDataContainer in
            self.tutorialViewModels = TutorialDataContainer.infectedByRegion.map { TutorialViewModel($0) }
            // MARK: print(self.tutorialViewModels)
        })
    }
    
}
 
struct TutorialViewModel: Hashable {
    private let tutorial: Tutorial
    
    var region: String {
        return tutorial.region
    }/var/folders/y5/31cd8scn3mlb8f37ph1mgshw0000gn/T/TemporaryItems/(A Document Being Saved By screencaptureui 3)/Screen Recording 2020-06-09 at 10.34.17 AM.mov
    var formattedInfectedCount: String {
        // TODO: format
        
        return String(tutorial.infectedCount)
    }
    
    init(_ tutorial: Tutorial) {
        self.tutorial = tutorial
    }
}




struct TutorialListView_Previews: PreviewProvider {
    static var previews: some View {
        InfectionListView()
    }
}
