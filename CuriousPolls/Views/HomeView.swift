//
//  HomeView.swift
//  CuriousPolls
//
//  Created by Rosa Jeon on 2023-07-18.
//

import SwiftUI

struct HomeView: View {
    
    @Bindable var vm = HomeViewModel()
    
    var body: some View {
        List {
            existingPollSection
            livePollsSection
            createPollsSection
            addOptionsSection
        }
        .alert("Error", isPresented: .constant(vm.error != nil)) {
            
        } message: {
            Text(vm.error ?? "an error occurred")
        }
        .sheet(item: $vm.modalPollId) { id in
            NavigationStack {
                PollView(vm: .init(pollId: id))
            }
        }
        .navigationTitle("CuriousPolls")
        .onAppear {
            vm.listenToLivePolls()
        }
    }
    
    var existingPollSection: some View {
        Section {
            DisclosureGroup("Join a Poll") {
                HStack {
                    TextField("Enter poll ID", text: $vm.existingPollId)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    Button(action: {
                        if let pollId = UIPasteboard.general.string {
                            vm.existingPollId = pollId
                        }
                    }) {
                        Image(systemName: "doc.on.clipboard")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                Button("Join") {
                    Task { await vm.joinExistingPoll() }
                }.disabled(vm.isJoinPollButtonDisabled)
            }
        }
    }
    
    var livePollsSection: some View {
        Section {
            DisclosureGroup("Latest Live Polls") {
                ForEach(vm.polls) { poll in
                    VStack {
                        HStack(alignment: .top) {
                            Text(poll.name)
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                            Text(String(poll.totalCount))
                            if let updatedAt = poll.updatedAt {
                                Image(systemName: "clock.fill")
                                Text(updatedAt, style: .time)
                            }
                        }
                        PollChartView(options: poll.options)
                            .frame(height: 160)
                    }
                    .padding(.vertical)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.vm.modalPollId = poll.id
                    }
                }
            }
            
        }
    }
    
    var createPollsSection: some View {
        Section {
            TextField("Enter poll name", text: $vm.newPollName, axis: .vertical)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            Button("Submit") {
                Task { await vm.createNewPoll() }
            }.disabled(vm.isCreateNewPollButtonDisabled)
            
            if vm.isLoading {
                ProgressView()
            }
            
        } header: {
            Text("Create a Poll")
        } footer: {
            Text("Enter a Poll name & add max 4 options")
        }
    }
    
    var addOptionsSection: some View {
        Section("Options") {
            
            
            ForEach(vm.newPollOptions) {
                Text($0)
            }.onDelete { indexSet in
                vm.newPollOptions.remove(atOffsets: indexSet)
            }
            
            TextField("Enter option name", text: $vm.newOptionName)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button("+ Add Option") {
                vm.addOption()
            }.disabled(vm.isAddOptionsButtonDisabled)
        }
    }
}

extension String: Identifiable {
    public var id: Self { self }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
