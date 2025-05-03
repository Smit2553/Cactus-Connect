//
//  ContentView.swift
//  Cactus Connect
//
//  Created by Smit Devrukhkar on 4/18/25.
//

import SwiftUI

// No explicit import needed as EventItem.swift is in the same module

struct ContentView: View {
    @State private var searchText = ""
    @State private var eventItems: [EventItem] = []
    @State private var isLoading = false
    
    // Example UUIDs to fetch
    let eventUUIDs = [
        "1968fdf2-934b-4a67-b782-088979a1e8a6",
        "ca3430c3-ac16-491f-bc27-4da2907683fd",
        "56ac2108-7eb2-4d55-ade3-a108e1822550",
        "691bcddf-c062-4c8e-9d45-f9f239b2001f",
        "01f5738e-7cfc-448c-9ec1-4c454da5b5a9",
        "633740d7-73b5-45ac-b7d0-5606302c2e64",
        "13a767a-b5ac-4a07-9f8d-300ba5adc955",
        "da068bfd-72c8-49a1-bb00-05ce7b32a386",
        "33283468-0cb6-47da-9f8c-63c9243805d4"
        
    ]
    
    struct APIEvent: Decodable {
        let uuid: String
        let name: String
        let url: String?
        let description: String
        let category: String
        let location: String
        let date: String
    }
    
    func fetchEvents() async {
        isLoading = true
        var loadedEvents: [EventItem] = []
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        for uuid in eventUUIDs {
            guard let url = URL(string: "https://cactusapi.codestacx.com/events/\(uuid)") else { continue }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let apiEvent = try JSONDecoder().decode(APIEvent.self, from: data)
                let eventDate = dateFormatter.date(from: apiEvent.date) ?? Date()
                let event = EventItem(
                    title: apiEvent.name,
                    subtitle: apiEvent.description,
                    date: eventDate,
                    eventType: apiEvent.category,
                    location: apiEvent.location,
                    url: apiEvent.url != nil ? URL(string: apiEvent.url!) : nil
                )
                loadedEvents.append(event)
            } catch {
                // Handle error or skip
                continue
            }
        }
        eventItems = loadedEvents
        isLoading = false
    }
    
    var filteredEvents: [EventItem] {
        if searchText.isEmpty {
            return eventItems
        } else {
            return eventItems.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.subtitle.localizedCaseInsensitiveContains(searchText) ||
                event.eventType.localizedCaseInsensitiveContains(searchText) ||
                event.location.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView("Loading events...")
                    .navigationTitle("Cactus Events")
            } else {
                List(filteredEvents, id: \.ID) { event in
                    NavigationLink(destination: EventDetails(event: event)) {
                        EventItemView(event: event)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear) 
                }
                .listStyle(.plain)
                .navigationTitle("Cactus Events")
                .searchable(text: $searchText, prompt: "Search events")
            }
        }
        .task {
            await fetchEvents()
        }
    }
}

#Preview {
    ContentView()
}
