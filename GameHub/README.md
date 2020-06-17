# UdacityProjects

General Information

This project is my Capstone project of the iOS Nanodegree program.
GameHub is a "Search - Save - Share" app in which the user can search for games, save them to their favourites list and share them with friends via message.

The IGDB Gaming Database contains +125.000 different games and provides various endpoints which I have used for this project. Further information can be found under: https://www.igdb.com/discover

The App has a NavigationController and a TabBarController.
The user can switch between the tab "Search Game" and "Favourite Games" which each represent the SearchViewController and ListViewController.

The SearchViewController provides a SearchByName and SearchByGenre function.
SearchByName accepts a String input and searches for games which are similar to the game and segues to the DetailViewController when pressing enter.
SearchByGenre accepts a genreIdentifier which will be chosen via the PickerView and segues to the DetailViewController when  the SearchByGenre button is pressed.

The DetailViewController displays 25 games according to the search input including the cover and the name of the game in a table view. Tapping on a cell opens an AlertView in which the user is asked to "Save the Game" to the ListViewController or "Cancel action".

The ListViewController displays all saved games of the user in a table view. Closing and restarting the app does not affect the data, it is persistent. Swiping to the left deletes the game object from Core Data. Tapping on the Cell opens an AlertView in which the user is asked to "Share", to "Visit" or to "Cancel action".
Tapping "Share" presents an ActivityViewController in which the user can send the URL of the website of the current game to a friend.
Tapping "Visit" opens Safari with the given URL of the current game.
