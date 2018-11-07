# YourApp
A simple Todo app for iOS

## Features
- add/edit tasks
- swipe to delete tasks directly or from task detail
- choose a category color for urgency classification
- create own categories and add them to tasks
- choose a due date to be notified
- enable/disable notifications from settings


## Missing features to be added and bugs
- missign option to delete task categories
  - Solution: A simple picker from settings page  
  - Better solution: Table view as a subview of settings view  
- notifications are not removed if task is deleted
  - Solution: Add a notification ID to Task in datamodel and delete accordingly
- missing progress wheel when adding/updating a task to avoid popping task in table view
- strucked task when done are not very user friendly
  - Solution: Replace struck trough with a checkbox or cell dimming and move finished tasks to bottom
- Settings page is pushed from right
- not very user friendly UI
