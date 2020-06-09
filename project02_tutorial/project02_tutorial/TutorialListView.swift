//
//  ItemListTutorialView.swift
//  project02_tutorial
//
//  Created by Shinnosuke Kajiwara on 6/8/20.
//  Copyright © 2020 Shinnosuke Kajiwara. All rights reserved.
//

import SwiftUI
import Combine
 
struct COVID19InfectionListView: View {
    private let viewModel = TutorialListViewModel()
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                self.viewModel.fetchTutorials()
        }
    }
}

class TutorialListViewModel: ObservableObject {
    
    private let tutorialApiService = TutorialApiService()
    @Published private var tutorialViewModels = [TutorialViewModel]()
    
    var cancellable: AnyCancellable?
    
    func fetchTutorials() {
        cancellable = tutorialApiService.fetchTutorials().sink(receiveCompletion: { _ in
            
        }, receiveValue: { TutorialDataContainer in
            self.tutorialViewModels = TutorialDataContainer.data.tutorials.map { TutorialViewModel($0) }
            print(self.tutorialViewModels)
        })
    }
    
}
 
struct TutorialViewModel {
    private let tutorial: Tutorial
    
    var name: String {
        return tutorial.name
    }
    var formattedSubName: String {
        // TODO:
        return tutorial.subName
    }
    
    init(_ tutorial: Tutorial) {
        self.tutorial = tutorial
    }
}




struct TutorialListView_Previews: PreviewProvider {
    static var previews: some View {
        COVID19InfectionListView()
    }
}
/*
   var tutorials: Array<Tutorial>
   struct Tutorial: Identifiable {
       var id: Int
       var name: String
       var lessons: Array<Lesson>
   }
   struct Lesson: Identifiable {
       var id: Int
       var name: String
       var summary: String
       var answer: String
   }
*/
