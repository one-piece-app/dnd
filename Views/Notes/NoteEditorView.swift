//
//  NoteEditorView.swift
//  DNDCompanion
//
//  Created by Ivanov Garcia on 2/25/26.
//

import SwiftUI

struct NoteEditorView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    @Environment(\.dismiss) private var dismiss
    
    var note: NoteEntity?
    
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
                    vm.updateNote(note, title: title, content: content, category: category)
                } else {
                    vm.addNote(title: title, content: content, category: category)
                }
                dismiss()
            }
        }
        .onAppear {
            if let note = note {
                title = note.title ?? ""
                content = note.content ?? ""
                category = note.category ?? "Campaign"
            }
        }
        .navigationTitle("Note")
    }
}
