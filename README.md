# About Jottr
Jottr makes it easier to write a short story, interactive fiction, or boxed text for your favorite ttrpg. The app uses OpenAI API to genererate any story you desire, just input some text as a prompt, and the OpenAI model will generate a text completion that attempts to match whatever context or pattern you gave it. 
What you actually read may differ every time you call it with the same prompt, because the API is stochastic by default. So you may get a slightly different text completion every time you call it. 

# Getting Started
In iOS, we traditionally use *Plist* (short for property list) files to store and manage configuration data. Plist files 
are essentially XML files with benefits; for example Xcode provides a graphical editor to make editing Plist files more 
pleasant. For accessing the Plist, I've added an easy-to-use API for reading Plist files.

## The steps to get the app up and running are:
1. Obtain an API key
2. Add a Plist file to your project
3. Define the keys/values in the Plist file
4. Reading the API key from the Plist file

## First
Let's go to [OpenAI](https://www.openai.com) and sign up for a developer account and follow the instructions to get 
an API keys.

## Second
Add a new Plist file to your project, make sure to select the project's root folder in the project navigator which is 
the JottrDemo, and then either click on said folder for a context menu and choose New File, or in the top navigation click 
File -> New -> File...

Then type *property* into the filter field on the top right of the popup window and then choose the Property File type 
from the Resource section.

Choosing a good name for your property list file is essential. I recommend the following naming scheme: 
<name of the API>Info.plist. For example, we are accessing OpenAI, so we'll name the file OpenAI-Info.plist

## Third
Next, go ahead and add a new key/value pair to the newly created file by clicking the tiny plus sign adjacent to **Type**. 
I'd chose API_KEY as the name for the **Key**. Most API keys are strings, so choose String as the data type in **Type**, 
and then insert the key you get from OpenAI into the **Value** field.

## Fourth
Now to read the API key and using it in the code as easy as possible, I've wrapped it in a computed property that 
will also give us the opportunity to perform some error handling. You'll find the code within 
Model/APIClient/OpenAIConnector.swift file and I've named it openAIKey. 
Don't need to worry too much about this step since the code has been written, but if you run into any problems or need to adjust the computed property the location above is where you'll find the Plist reader.

After all that just run the app and hopefully you'll be able to generate some exciting stories.

# Overview
Jottr's interface has three main views you should get familiar with:

- Collection
- Page List
- Editor

The **collection** allows access to your texts and it is divided into sections. Such as **entirety** the name says it all, **recent** which contains your written work from the past seven days, and **trash** where any deleted content will be held for thirty days which at that point it wiil be permanently deleted.

The *collection list* is where all your and the AI co-writer written texts lives.

And the *editor* where all the magic happens. Simply write and your AI co-writer will complete your texts.

## Basic Navigation
To switch between the three main views simply tap on the links, and to go back use the navigation bar or tap done. 

## Pages
All generated content is done on Jottr custom text editor I like to call *pages*. Pages are similar to Notes, in that a title or a file name isn't required and the pages are saved automatically. Pages can hold any amount of text.
You request pages via the navigation bar *New Page* 􀈎 button found in the collection/page list or in the editor.

## Editor
You'll arrive at the *editor* by either tapping *New Page* 􀈎 button on the navigation bar or tap one of the *pages* in the *page list* where you can edit your work. 

Once there, at the bottom right is the *Genre* picker where you can set the genre of the story and on top from the right, if the iPhone's virtual keyboard is active, you'll see the *New Page* 􀈎, *Menu* 􀍡, and a *Submit* 􀄨 button. The *Submit* button is hidden when the virtual keyboard becomes inactive. When active the virtual keyboard will have a button row sitting directly above it. Far right there's the dismiss keyboard icon and next to that is the *Genre* picker again.

Back to the navigation bar above you can tap the *Menu* 􀍡 button to access the *Export*, *Share*, and *Prompt Editor* options. *Export* gives you the option to save the text to your device either as plain text, pdf, or epub. With *Share* you can well share with your peers the current text shown in the editor. And the *Prompt Editor* allows you the write the backstory, set the theme, premise, and the genre of the story which all of it get's concatenate and sent to OpenAI API as a prompt parameter, and there's a link to more advance setting where you can adjust other AI parameters. When you have completed your set up tap on 􀃜 *Add Prompt* button to submit it to OpenAI API and then shortly you should be receiving back a generated story for your reading pleasure.

## Account Settings
Starting at the top you can *Login* into your account(work in progress) where your username will be used as a unique identifier, which can help OpenAI to monitor and detect abuse and save other account settings. The *Contact Support* link will allow to send me an email for any support or question the user may have. Next up, *Leave Feedback*(work in progress) should open up a store review alert view so the user can leave an app review in the app store. After that is the *AI Settings* allowing you to adjust the AI parameters. And at the end is the *Logout* link, tap it to logout of your account.
