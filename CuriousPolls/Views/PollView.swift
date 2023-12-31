//
//  PollView.swift
//  CuriousPolls
//
//  Created by Rosa Jeon on 2023-07-18.
//

import SwiftUI
import UIKit

struct PollView: View {
    var vm: PollViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isDeleteAlertPresented = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Poll ID")
                        Text(vm.pollId)
                            .font(.caption)
                            .textSelection(.enabled)
                    }
                    Spacer()
                    Button(action: {
                        UIPasteboard.general.string = vm.pollId
                    }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                HStack {
                    Text("Updated at")
                    Spacer()
                    if let updatedAt = vm.poll?.updatedAt {
                        Text(updatedAt, style: .time)
                    }
                }
                
                HStack {
                    Text("Total Vote Count")
                    Spacer()
                    if let totalCount = vm.poll?.totalCount {
                        Text(String(totalCount))
                    }
                }
            }
            
            if let options = vm.poll?.options {
                Section {
                    PollChartView(options: options)
                        .frame(height: 200)
                        .padding(.vertical)
                }
                
                Section("Vote") {
                    ForEach(options) { option in
                        Button(action: {
                            vm.incrementOption(option)
                        }, label: {
                            HStack {
                                Text("+1")
                                Text(option.name)
                                Spacer()
                                Text(String(option.count))
                            }
                        })
                    }
                }
            }
            
            Button("Delete Poll") {
                isDeleteAlertPresented = true
            }
            .foregroundColor(.red)
            .alert(isPresented: $isDeleteAlertPresented) {
                Alert(
                    title: Text("Delete Poll"),
                    message: Text("Are you sure you want to delete this poll?"),
                    primaryButton: .destructive(Text("Delete")) {
                        Task { await vm.deletePoll() }
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
        .navigationTitle(vm.poll?.name ?? "")
        .onAppear {
            vm.listenToPoll()
        }
    }
}

#Preview {
    NavigationStack {
        PollView(vm: .init(pollId: "tWJlfYzfDtWLrAeaWxd4"))
    }
}
