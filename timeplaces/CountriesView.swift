import SwiftUI

struct CountriesView: View {
    let selectedTime: Date
    @State private var locationsWithTime: [(location: String, localTime: Date)] = []
    
    private func formatLocation(_ timeZoneId: String) -> String {
        let components = timeZoneId.split(separator: "/")
        if components.count >= 2 {
            let city = components.last?.replacingOccurrences(of: "_", with: " ") ?? ""
            let region = components[components.count - 2]
            return "\(city), \(region)"
        }
        return timeZoneId
    }
    
    private func getCountryCode(from region: String) -> String {
        switch region {
        case "America": return "USA"
        case "Asia": return "ASIA"
        case "Africa": return "AFR"
        case "Europe": return "EUR"
        case "Pacific": return "PAC"
        case "Australia": return "AUS"
        case "Indian": return "IND"
        case "Atlantic": return "ATL"
        default: return region
        }
    }
    
    func findCountriesWithTime() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: selectedTime)
        let selectedHour = components.hour ?? 0
        let selectedMinute = components.minute ?? 0
        let selectedTotalMinutes = selectedHour * 60 + selectedMinute
        
        let timeZones = TimeZone.knownTimeZoneIdentifiers
        let currentDate = Date()
        
        locationsWithTime = timeZones.compactMap { timeZoneId in
            guard let timeZone = TimeZone(identifier: timeZoneId) else { 
                return ("", currentDate)
            }
            
            var calendar = Calendar.current
            calendar.timeZone = timeZone
            let tzComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
            
            let tzHour = tzComponents.hour ?? 0
            let tzMinute = tzComponents.minute ?? 0
            let tzTotalMinutes = tzHour * 60 + tzMinute
            
            let timeDifference = abs(tzTotalMinutes - selectedTotalMinutes)
            let isWithinWindow = timeDifference <= 30 || timeDifference >= (24 * 60 - 30)
            
            if isWithinWindow {
                let location = formatLocation(timeZoneId)
                return (location: location, localTime: currentDate)
            }
            return ("", currentDate)
        }.filter { !$0.location.isEmpty }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Showing locations where the current time is within 30 minutes of \(formatTime(selectedTime, for: TimeZone.current.identifier))")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            List {
                ForEach(locationsWithTime, id: \.location) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.location)
                            .font(.headline)
                        Text("Current time: \(formatTime(item.localTime, for: item.location))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Matching Locations")
        .onAppear {
            findCountriesWithTime()
        }
    }
    
    private func formatTime(_ date: Date, for location: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        // Find the timezone for this location
        if let timeZone = TimeZone.knownTimeZoneIdentifiers.first(where: { 
            formatLocation($0) == location 
        }) {
            formatter.timeZone = TimeZone(identifier: timeZone)
        }
        
        return formatter.string(from: date)
    }
} 
