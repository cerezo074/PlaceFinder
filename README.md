# PlaceFinder

PlaceFinder is a SwiftUI-based app designed to help users browse and explore cities. It leverages a clean and dynamic interface to provide a seamless experience for filtering, viewing, and managing favorite cities. The app also includes navigation capabilities and ensures a responsive user experience across device orientations.

## Features

### City List and Filtering
- Download a list of cities from a provided gist.
- Filter cities using a prefix string (case-insensitive) with optimized search performance.
- Update the city list dynamically as the user types, ensuring responsiveness.
- Sort cities alphabetically by city name, followed by country name (e.g., "Denver, US" before "Sydney, Australia").
- Allow users to filter results to show only favorite cities.

### City Details
- Display each city with:
  - City and country code as the title.
  - Coordinates (longitude and latitude) as subtitles.
  - A toggle to mark the city as a favorite.
- Provide a button to navigate to an information screen about the selected city.
- Tap on a city to navigate its location on the map.

### Dynamic UI
- Adapt UI layout based on device orientation:
  - Use separate screens for the list and map in portrait mode.
  - Display both the master (list) and detail (map) views simultaneously in landscape mode or on larger screens.

### Favorites Management
- Allow users to mark cities as favorites.
- Persist favorite cities across app launches using SwiftData for offline storage.
- Use a Trie data structure for efficient prefix searching on favorite cities.

### Map Integration
- Use MapKit to display city locations based on latitude and longitude coordinates.

### Testing
- Include unit tests for the search algorithm to verify correct results for various inputs (valid and invalid).
- Provide UI and unit tests for the city information screen.

## Technical Implementation

### Core Technologies
- **SwiftUI**: For building the user interface.
- **SwiftData**: For storing city data offline and persisting favorite cities.
- **MapKit**: For displaying city locations on a map.
- **Combine**: For managing state and implementing debounce functionality for search input.
- **NavigationSplitView**: For adaptive navigation, displaying master and detail views simultaneously in landscape mode or on larger screens.
- **Async/Await**: For handling asynchronous tasks such as data loading.
- **SwiftTests**: For comprehensive unit and UI testing.
- **Trie Data Structure**: For efficient prefix searching on favorite cities.

## How It Works
1. The app downloads and processes a city list from the specified gist.
2. Users can filter cities dynamically by typing a prefix string, with results updated instantly.
3. Selecting a city displays its location on a map and provides additional information.
4. Users can toggle favorite cities, with preferences saved for future sessions.
5. The interface adapts automatically to the device's orientation, offering a split-view experience in landscape mode.

## Setup and Usage
1. Clone the repository and open the project in Xcode.
2. Run the app on a simulator or device with iOS 16 or later.
3. Interact with the city list, filter results, and explore cities on the map.

## Testing
- Use the provided test suite to validate search functionality and UI components.
- Run tests using Xcode’s built-in testing tools to ensure reliability and correctness.

PlaceFinder is a powerful tool for exploring cities with a focus on performance, user experience, and adaptability. Its clean architecture and modern SwiftUI features make it a robust and efficient app for users.
