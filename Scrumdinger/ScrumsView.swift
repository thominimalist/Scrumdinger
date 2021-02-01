//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Thomas Ruchon on 29/01/2021.
//

import SwiftUI

struct ScrumsView: View {
  @Binding var scrums: [DailyScrum]
  
  @State private var isPresented = false
  @State private var newScrumData = DailyScrum.Data()
  
  @Environment(\.scenePhase) private var scenePhase

  let saveAction: () -> Void
  
  var body: some View {
    List {
      ForEach(scrums) { scrum in
        NavigationLink(destination: DetailView(scrum: binding(for: scrum), onDelete: deleteScrum)) {
          CardView(scrum: scrum)
        }
        .listRowBackground(scrum.color)
        .listStyle(PlainListStyle())
      }
    }
    .navigationTitle("Daily Scrums")
    .navigationBarItems(trailing: Button(action: {
      isPresented = true
    }) {
      Image(systemName: "plus")
    })
    .sheet(isPresented: $isPresented) {
      NavigationView {
        EditView(scrumData: $newScrumData)
          .navigationBarItems(leading: Button("Dismiss") {
            isPresented = false
          }, trailing: Button("Add") {
            let newScrum = DailyScrum(title: newScrumData.title, attendees: newScrumData.attendees,
                                      lengthInMinutes: Int(newScrumData.lengthInMinutes), color: newScrumData.color)
            scrums.append(newScrum)
            isPresented = false
          })
      }
    }
    .onChange(of: scenePhase) { phase in
      if phase == .inactive { saveAction() }
    }
  }
  
  private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
    guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
      fatalError("Can't find scrum in array")
    }
    return $scrums[scrumIndex]
  }
    
    private func deleteScrum(id: UUID) {
        guard let scrumIndex = scrums.firstIndex(where: { $0.id == id }) else {
          fatalError("Can't find scrum in array")
        }
        scrums.remove(at: scrumIndex)
    }
}

struct ScrumsView_Previews: PreviewProvider { 
  static var previews: some View {
    NavigationView {
      ScrumsView(scrums: .constant(DailyScrum.data), saveAction: {})
    }
  }
}
