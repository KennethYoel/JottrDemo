#  How To Run The App

In iOS, we traditionally use *Plist* (short for property list) files to store and manage configuration data. Plist files 
essentially are XML files with benefits: for example, Xcode provides a graphical editor to make editing Plist files more 
pleasant, and there's an easy-to-use API for reading Plist files.

## The steps to get the app up and running are:
1. Obtain an API key
2. Add a Plist file to your project
3. Define the keys/values in the Plist file
4. Read the API key from the Plist file

## First
First lets go to [OpenAI](https://www.openai.com) and sign up for a developer account and follow the instructions to get 
some API keys.

## Second
Add a new Plist file to your project, make sure to select the project's root folder in the project navigator which is 
the JottrDemo, and then either click on said folder for a context menu and choose New File, or in the top navigation click 
File -> New -> File...

Then type *property* into the filter field on the top right of the popup window and then choose the Property File type from 
the Resource section.

Choosing a good name for your property list file is essential. I recommend the following naming scheme: <name of the 
API>Info.plist. For example, we are accessing OpenAI, so we'll name the file OpenAI-Info.plist

## Third
Next, go ahead and add a new key/value pair to the newly created file by clicking the tiny plus sign adjacent to **Type**. 
I chose API_KEY as the name for the **Key**. Most API keys are strings, so choose String as the data type in **Type**, and 
then insert the key you get from OpenAI into the **Value** field.

## Fourth
Now to make reading the API key and using it in the code as easy as possible, I've wrapped it in a computed property. This 
will also give us the opportunity to perform some error handling. You'll find the code within 
Model/APIClient/OpenAIConnector.swift file and I've named it openAIKey. 
You may be wondering why I've added this step? Because I want you too see how hard it was creating this app.

After all that just run the app and hopefully you'll be able to generate some stories.
