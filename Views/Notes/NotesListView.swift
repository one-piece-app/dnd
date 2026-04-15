//
//  NotesListView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

struct NotesListView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    
    @State private var showCreate = false
    
    var body: some View {
        List {
            ForEach(vm.notes, id: \.objectID) { note in
                NavigationLink(note.title ?? "") {
                    NoteEditorView(note: note)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    vm.deleteNote(at: index)
                }
            }
        }
        .navigationTitle("Notes")
        .toolbar {
            Button {
                showCreate = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showCreate) {
            NoteEditorView()
        }
    }
}
