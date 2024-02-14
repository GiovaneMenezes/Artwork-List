# Artwork-List

## Description

iOS app to present the list of artwork using the ARTIC (Art Institute of Chicago) API. It contains two screens:
- List
- Details

The app stores the first page when a new list is started. And in case of error on the api, it returns that stored page.

## Screenshots

| Screen | Screenshot |
| -------------| --------------------- |
| List Screen   | <img src="https://github.com/GiovaneMenezes/Artwork-List/assets/9324224/7a88d3f6-b936-4795-acb6-00cb093c06bf" width="300"> |
| Details Screen| <img src="https://github.com/GiovaneMenezes/Artwork-List/assets/9324224/1d53d2b8-9e07-4947-904c-43f0d86e9229" width="300"> |


## Architectural Decisions

### Architectural segregation

#### Presentation

- Scenes
  - View
  - ViewModel

#### Domain

- Models

#### Data

- Repository
- Services
- APIs

### Scene architetural Pattern

MVVM (Model-View-ViewModel)
Selected due the testability of the layers of the coordinator

### Navigation

Coordinator
Delegates the navigation responsibility to another entity, making the code more reusable and easier to test.

## Instructions

To run the app:
1. Clone the project repository.
2. Open the project in Xcode.
3. Select a simulator or device to run the app on.
4. Press the "Run" button to build and launch the app.

## Dependencies

There is no additional dependencies to run this app.

## To Do

- Implementing snapshot testing
