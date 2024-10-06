# Budget Buddy

An app that can help track bills using the camera sensor in Flutter. 
This Flutter app is for the everyday consumer or anyone wanting to keep track of bills and payments. 
Budget Buddy is useful for its abilites to list bills in either a calendar or list format, helping you pay bills on time with easy-to-access information. 
The app is divided into two main screens which can be selected with a bar on the bottom of the screen: Calendar View and List View. 

## Calendar View
The Calendar View represents bills due on certain dates via dots. You can change view to display a whole month, a two week period, or the current week. 
Pressing and holding on a date reveals a List View for that specific date.

![Calendar View](https://github.com/404thecomputer/budget-buddy/blob/main/budget_buddy/images/calendar.png)

## List View
The List View displays the list of bills either in total (by selecting the List View screen from the bottom bar) or for a certain day (by pressing and holding a date on Calendar View).
Each item will display its name, date, amount, and frequency. Tapping on an item will open a dialog displaying this information in detail, as well as the options to add or view a picture or delete the bill.

![List View](https://github.com/404thecomputer/budget-buddy/blob/main/budget_buddy/images/listview.png)
![Info Dialog](https://github.com/404thecomputer/budget-buddy/blob/main/budget_buddy/images/infoDialog.png)

## Adding a new bill
Tapping the floating action button opens a dialog for adding bills. You can enter in a name and numerical amount and select the date and frequency of the bill. There is a button which opens up the camera, where you can take a picture of the bill, saving it to the bill item to be viewed when you tap the bill in the list view. 

![Add Dialog](https://github.com/404thecomputer/budget-buddy/blob/main/budget_buddy/images/addDialog.png)
![Camera](https://github.com/404thecomputer/budget-buddy/blob/main/budget_buddy/images/camera.png)