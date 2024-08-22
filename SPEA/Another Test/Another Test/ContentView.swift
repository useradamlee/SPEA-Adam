//
//  ContentView.swift
//  Another Test
//
//  Created by Lee Jun Lei Adam on 20/8/24.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
    }
}

struct ContentView: View {
    var body: some View {
        PDFViewer(url: URL(string: "https://drive.google.com/uc?export=download&id=11aYI9PFO-DyCXD9r9T8IoG8ESWPF9fet")!)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
