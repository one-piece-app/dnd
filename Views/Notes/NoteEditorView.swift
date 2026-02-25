//
//  NoteEditorView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI
import SwiftData

struct NoteEditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var note: Note?
    
    @State private var title = ""
    @State private var content = ""
    @State private var category = "Campaign"
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            
            TextEditor(text: $content)
                .frame(height: 200)
            
            Picker("Category", selection: $category) {
                Text("Campaign").tag("Campaign")
                Text("NPC").tag("NPC")
                Text("Quest").tag("Quest")
                Text("Session").tag("Session")
            }
            
            Button("Save") {
                if let note = note {
                    note.title = title
                    note.content = content
                    note.category = category
                } else {
                    let newNote = Note(
                        title: title,
                        content: content,
                        category: category
                    )
                    context.insert(newNote)
                }
                dismiss()
            }
        }
        .onAppear {
            if let note = note {
                title = note.title
                content = note.content
                category = note.category
            }
        }
        .navigationTitle("Note")
    }
}
