# SwiftLingo
<img src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/50affc0b-cb85-4b19-810a-8869f8094d1c" alt="1024" width="180">

SwiftLingo is a revamped version of AI Translate.

Rebuilt with SwiftUI, SwiftLingo offers a more comprehensive app experience, featuring a fresh design, additional functionalities and an enhanced user experience.

SwiftLingo supports translation to and from 29 languages using the DeepL Translator API (https://rapidapi.com/splintPRO/api/deepl-translator)

Just like AI Translate, SwiftLingo utilizes Firebase for user authentication and Firebase Firestore as its database.

<img width="220" alt="Screenshot 2024-06-08 at 10 10 37" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/d511b7c4-0bbe-4d20-b8e4-f71e9ac22b19">
<img width="220" alt="Screenshot 2024-06-08 at 10 10 56" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/8faca8ca-fa35-437c-978f-0e55b37aef72">
<img width="350" alt="Screenshot 2024-06-08 at 10 08 48" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/9817bdc3-889b-43cd-86e0-f6383188a422">

Features in regards to user authentication and management include:
- A "password strength" indicator in the RegisterView to show how secure the password is
- A link to reset a forgotten password in LoginView
- An option to update a user's password
- An option to delete an account
- Improved error handling

<img width="220" alt="Screenshot 2024-06-08 at 10 07 09" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/50bb019a-b721-402d-94e5-97fa325a8503">

Each available language is coded as a LanguageModel struct, so that each one of them as its own name, flag, translations codes and text-to-speech code:

<img width="500" alt="Screenshot 2024-06-08 at 10 58 09" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/5bb1f8f9-9eda-4195-998d-d6a5c32fb777">
<img width="400" alt="Screenshot 2024-06-08 at 10 58 30" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/f0aa600a-f9ef-4c54-98f8-be4eb5dac54b">

Once a translation is retrieved, the user is able to hear its pronounciation, either at normal or slow speed, and save it as a favourite translation, provided they are registered as users.

To let users hear pronounciation I have decided to swap the API call implemented in AI Translate in favour of the built-in AVSpeechSynthesizer available in iOS.

<img width="220" alt="Screenshot 2024-06-08 at 10 08 02" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/59df7e34-44be-4dd7-8e7f-f163388cf174"> <img width="220" alt="Screenshot 2024-06-08 at 10 08 21" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/750b70c1-11b8-4f13-a543-4bbf2fcd19d1">

The Saved Translations view shows all of the translations saved by the user, for easy retrieval.
Each translation gives access to a detail view which shows the full translation and source text and includes buttons to hear the pronounciation (slow and normal speeds) and delete the translation from the database.

An extra feature included in SwiftLingo, which was not present in AI Translate, is a History view which displays the 10 most recent tranlsations that have been performed, regardless of whether they have been marked as favourites or not.

<img width="220" alt="Screenshot 2024-06-08 at 10 07 43" src="https://github.com/AndreaBot/SwiftLingo/assets/128467098/0c4f5705-2b44-429d-81fc-6b7137a3bac6">
