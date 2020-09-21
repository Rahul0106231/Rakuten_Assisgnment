# Rakuten_Assisgnment
IOS project for rakuten assignment.

Architecture Used (MVVM + Repository):
This project uses the MVVM + Repository architecture which Google's Jetpack is known for. It can be used both for IOS and Android.

Classes Description:

MapsViewController : This class represents the view , it just has the functionality to display the view.

MapsViewmodel : ViewController communicates with view model to get the data. This class in itself doesn't do anything apart from asking the data from Repository

MapsRepository : The core business logic resides in this class. It communicates with Database/APIClient to retrieve the data depending on any conditions.

APIClient : Responsible for making service calls and returning the results to Repository

CoreDataManager: Responsible for database initialisation , fetch and retrievals.


Functionality Logic:

We make an initial service call to crunch base open data map to retrieve all the rakuten 
locations. In order to show the marker on google maps , we need the latitudes and longitudes of these locations. For that to happen , we make another service call to google geocoding API . Unfortunately , since google geocoding API doesn't take an array of addresses , we have to make individual service call for each location. For better performance we make these service calls in concurrent dispatch queue .Once the results come back in , we sabe it to Database, so that from the next time , it always retrieves from database.

Another advantage of saving it to DB is it can provide offline support as well. We can use reachability class to detect the offline status.




