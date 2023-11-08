//
//  WebViewUI.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/11/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> some UIView {
        let wkwebView = WKWebView()
        let request = URLRequest(url: url)
        wkwebView.load(request)
        return wkwebView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

struct WebViewUI: View {
    var body: some View {
        WebView(url: URL(string: "https://www.youtube.com/embed/liJVSwOiiwg")!)
    }
}

#Preview {
    WebViewUI()
}
