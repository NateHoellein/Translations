//
//  TranslationsApp.swift
//  Translations
//
//  Created by nate on 10/7/24.
//

import SwiftUI

@main
struct TranslationsApp: App {
    @State var batchViewModel = BatchViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NavigationView {
                    TabView {
                        SingleTranslationView(viewModel: SingleViewModel())
                            .tabItem {
                                Label("Single", systemImage: "text.viewfinder")
                            }
                        BatchTranslationView().environment(batchViewModel)
                            .tabItem {
                                Label("Batch", systemImage: "text.redaction")
                            }
                    }
                }
                .navigationTitle("Translations")
            }
        }
    }
}
