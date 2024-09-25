# ReMind 
### _Tagline:_
ReMind: Helping you remember, stay safe, and on track.


## Description:
ReMind is an innovative mobile application designed specifically for individuals with Alzheimer's disease and their caregivers. The app assists users in managing daily tasks, medications, and routines through an intuitive and user-friendly interface. ReMind offers a personalized chatbot, powered by the Gemini API, that engages users in daily conversations to track their activities and well-being. These interactions generate insightful reports that are automatically logged into a memory journal, accessible by healthcare professionals to monitor the patient's condition over time.

In addition to its daily management tools, ReMind includes interactive games tailored to improve memory and cognitive skills. Users can enjoy a tile-matching game to enhance visual memory and a multiple-choice quiz that challenges recollection abilities. The app also prioritizes safety with an SOS feature, offering quick access to emergency contacts, locati on-based directions home, and a direct line to the police if needed.

### Target Audience:
ReMind is tailored for individuals with Alzheimer's disease, providing them with essential support to maintain their independence and well-being. It is also a valuable tool for caregivers and healthcare professionals, offering insights into the patient's daily routine and cognitive progress.

## Team Members:
- Arshati
- Farheen
- Gauri 
- Pooja
- Prasitha

## Contributions:
### **Arshati**
Contributed significantly to the frontend development of several key features in the application:
1. Calendar Feature: Developed the calendar interface with event management functionality. Implemented a popup to display events for selected dates, ensuring users can view and interact with event details effectively. Linked calendar events with daily tasks on the home page for a consolidated view of activities.
2. Memory Log Page: Linked the memory log with the journal content to display journal entries effectively, ensuring a seamless integration of user data with the journal interface.
3. Settings Page: Created and styled the settings page, linking the voice-over settings option to allow users to switch between male and female voice options, enhancing accessibility and personalization.
4. Login and Sign-Up Pages: Built the frontend for login and sign-up, focusing on a seamless and secure user authentication process.
Patient Details, Caretaker Details, and Emergency Contact Pages: Designed and developed the frontend for managing patient details, caretaker information, and emergency contacts, ensuring clear and efficient data presentation.

### **Farheen**
1. Firebase and GitHub Setup
As part of the ReMind project, I took the initiative to establish the foundational infrastructure by setting up Firebase for backend support and creating the GitHub repository to ensure smooth version control and collaboration within the team.

2. Memory Card Game
I developed the Memory Card Game, a classic matching game designed to help users engage their memory. Players select images from their gallery, which are then used as the game’s cards. The objective is to match pairs of cards by flipping them over. To enhance the gameplay experience, I implemented a hint system that briefly reveals two cards after 3 or 4 incorrect matches, helping users recall the card positions and improve their chances of making correct matches.

3. Memory Quiz Game
In addition, I worked on the Memory Quiz Game, a customizable tool that allows users to create quizzes by adding questions and answers. These are stored in Firebase for easy access and modification. The game retrieves these quizzes for users to play, and any updates made in the settings are automatically reflected in the gameplay. To support learning, I added a feature that reveals the correct answer after two incorrect attempts, aiding users in retaining the information more effectively.

### **Gauri**
Below are my Backend and Frontend Contributions to the application:

1. Gemini Chatbot Integration:
   - Engineered prompts to guide the Gemini chatbot in conversing empathetically with Alzheimer's patients, ensuring the dialogue is both supportive and informative.
   - Leveraged Gemini Flash 1.5 to develop a chatbot that engages patients in daily conversations, subtly inquiring about key Alzheimer's indicators, including:
     - Difficulty with daily tasks
     - Language and communication challenges
     - Confusion and disorientation
     - Loss of initiative
     - Mood and behavioral changes
     - Physical symptoms and movement issues
     - Sleep disturbances
   - Implemented sentiment analysis on patient responses to assess their emotional state.
   - Developed a system to generate comprehensive reports summarizing patient responses, mood, and behavior, which are then automatically stored in a memory log within Firebase.
   - Developed a chat user interface with microphone (speech-to-text) and read-aloud (text-to-speech) features. Also developed the voice settings page to change the volume, pitch, and speech rate of the voice for the read-aloud feature. The user can also switch between the male and female voices.

2. Memory Log Management:
   - Designed and implemented the backend logic for storing and retrieving reports generated by the Gemini chatbot from Firebase.
   - Created a user interface to display a list of all reports, with an option to view detailed journal entries.
   - Ensured that each entry in the memory log captures the date, time, and a summary of the conversation, providing healthcare professionals with insights into the patient's cognitive progress and daily routine.

3. Calendar Feature Implementation:
   - Developed backend functionalities for managing calendar events, including creating, updating, deleting, and displaying events.
   - Integrated Firebase to store and fetch user-created events, ensuring seamless data synchronization and display within the app.

### **Pooja**
In this project, I played a pivotal role in developing the backend infrastructure that supports core functionalities crucial for user interaction and data management. I implemented a robust authentication system using Firebase, which provides secure login and sign-up capabilities, ensuring user data protection and access control. I designed and developed backend services for managing caretaker and patient details, including emergency data, which involves capturing user inputs, validating them, and storing them efficiently in the database. Additionally, I created a comprehensive medicine management system, which encompasses adding new medicines through a detailed form and backend functionality for editing, displaying, and deleting medicine records. This ensures that users can manage their medicine inventory effectively. It also focuses on enhancing user experience by enabling backend support for editing patient profiles, updating emergency information, and modifying caretaker details. A significant feature I integrated is the SOS button, which encompasses several emergency functions: locating the nearest police station, route to the nearest safe place, individuals, and sending immediate alerts to nearby responders. This feature is designed to enhance user safety and provide quick access to emergency services.

### **Prasitha**
Developed the initial app prototype design using Figma.
Created a custom logo for the app.

Frontend Development:

Worked on the frontend design and implementation of the following pages in the Remind Flutter app:

- Home Page
- Profile Page
- Medication Management (view, add, edit)
- Games (Match Game, Quiz Game, edit game)

Made sure the UI was consistent in all the pages throughout the application.

Backend Integration:

Collaborated with team members to link the frontend with the backend for the following pages:

- Medicine
- Profile
- Login
- Sign-Up
- Games


<!-- ## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference. -->

