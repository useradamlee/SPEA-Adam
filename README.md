## Features:
1. **Membership management**
Upon app start-up for the first time, the app will prompt the user whether he/she is a member or just someone looking at updates.
If the person says yes, a membership detail will pop up, and the user will be asked to fill in some information, such as the sign-up date and membership type.
Once that is over, users will see a membership card with all the details when they go to the membership section. If the membership closes to expiration, it will notify the user to renew their membership.
If the person says no, they will just be directed to the app's main page. With the option of recording down information if they choose to become a member


2. **Newsletters:** 
This is relatively simple; there will be a view with previews of newsletters, and when the user presses it, it will link the user to the website. All of the data is stored locally.

4. **Events, announcements and membership benefits:**
This is a bit more complicated, but it simply works with a list. 
**How does it get data?** 
It gets data from a Google sheet
From the Google sheet, it is converted into a JSON file using Google App Scripts. App Scripts will then provide a web app link to the JSON formatted data.
I then can use the link and decode it in the app. After formatting the data, it will be shown in a list.
5. **Caching:**
Caching is used for most of the app, especially for the parts that get data from the Google sheet
It will cache the data for the text and the image. 
**How does it cache the image?** 
It caches the images through [KingFisher](https://github.com/onevcat/Kingfisher), firstly, the images are web-hosted and the direct link is put in the Google sheet. After all the processes, the app will get the images through the links, cache it and store it.

Lastly, if the content gets updated, the app will get rid of the changed content and fit the new one in

## Feature implementation
- [x] Remote changes for events
- [x] Remote changes for announcements
- [x] Remote changes for membership benefits
- [x] membership management (expiry date tracking, notifications, etc.)
- [x] push notifications
- [x] offline access
- [ ] sections of the newsletter in the app
- [ ] remote changes for newsletter
- [ ] home screen for app
- [ ] walkthrough of app
- [ ] android version
