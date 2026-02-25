//
//  NotesListView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import SwiftData

struct NotesListView: View {
    @Environment(\.modelContext) private var context
    @Query var notes: [Note]
    
    @State private var showCreate = false
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NavigationLink(note.title) {
                    NoteEditorView(note: note)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    context.delete(notes[index])
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
