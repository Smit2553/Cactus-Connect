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
        // Add more UUIDs as needed
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
            guard let url = URL(string: "https://x4gswcows00woccgsowkww0c.codestacx.com/events/\(uuid)") else { continue }
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
