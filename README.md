## Features:
1. **Membership management**
Upon app start-up for the first time, the app will prompt the user whether he/she is a member or just someone looking at updates.
If the person says yes, a membership detail will pop up, and the user will be asked to fill in some information, such as the sign-up date and membership type.
Once that is over, users will see a membership card with all the details when they go to the membership section. If the membership closes to expiration, it will notify the user to renew their membership.
If the person says no, they will be directed to the app's main page. With the option of recording down information if they choose to become a member

2. **Newsletters:** 
Recently updated to allow remote changes.
For the newer newsletters, it will show the newsletter sections with the ability to enter the link to that specific section (in a website).
For the older newsletters, since it is a pdf file, swiftui will get the link and with pdfkit, it will make it a viewable pdf file inside the app.
4. **Events, announcements and membership benefits:**
This is a bit more complicated, but it simply works with a list. 
**How does it get data?** 
It gets data from a Google sheet
From the Google sheet, it is converted into a JSON file using Google App Scripts. App Scripts will then provide a web app link to the JSON formatted data.
I then can use the link and decode it in the app. After formatting the data, it will be shown in a list.
5. **Caching:**
Caching is used for most of the app, especially for the parts that get data from the Google sheet.
It will cache the data for the text and the image.
Now, it will also cache the pdf file, so that it loads faster and reduces the fetching of the api
**How does it cache the image?** 
It caches the images through [KingFisher](https://github.com/onevcat/Kingfisher). Firstly, the images are web-hosted, and the direct link is put in the Google sheet. After all the processes, the app will get the images through the links, cache them and store them.

Lastly, if the content gets updated, the app will get rid of the changed content and fit the new one in

## Feature implementation
- [x] Remote updates for events
- [x] Remote updates for announcements
- [x] Remote updates for membership benefits
- [x] membership management (expiry date tracking, notifications, etc.)
- [x] push notifications
- [x] offline access
- [x] sections of the newsletter in the app
- [x] remote changes for newsletter
- [ ] home screen for app
- [ ] walkthrough of app
- [ ] Android version
+ more
