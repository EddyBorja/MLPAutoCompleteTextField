MLPAutoCompleteTextField
===================
"We believe that every tap a user makes drains a tiny bit of their energy and patience. Typing is one of the biggest expenditures of both. What we needed was a textfield that could be completed in as few keystrokes as possible even for very long words. Thus MLPAutoCompleteTextField was born."

![Alt text](/autocompleteDemo.png "Screenshot")

About
---------
MLPAutoCompleteTextField is a subclass of UITextField that behaves like a typical UITextField with one notable exception: it manages a drop down table of autocomplete suggestions that update as the user types. Its behavior may remind you of Google's autocomplete search feature.

Example: A user is required to enter a long and complicated chemical name into a textfield. With an autocomplete textfield, chemical names that closely match her entered string can be displayed as she types, and if she sees the chemical name she was thinking of she can select it and have it entered into the textfield automatically. This reduces the amount of typing she has to do and helps prevent errors. All this can occur within a single view and without the need for a search tableview controller.


Usage
---------
The goal for MLPAutoCompleteTextField is to create an autocomplete textfield that is quick and easy to use, yet eminently customizable. To get a working MLPAutoCompleteTextField instance, ensure you have done the following:

0) Add the MLPAutoCompleteTextField, NSString+Levenshtein, MLPAutoCompleteDataSource and MLPAutoCompleteTextFieldDelegate files into your project (should have six files in total). 

1) Have an MLPAutoCompleteTextField instance allocated and initialized within some view.

2) Set the textfield's "autoCompleteDataSource" property to a valid object that implements the required methods of the MLPAutoCompleteTextFieldDataSource protocol. Note that the method "possibleAutoCompleteSuggestionsForString:" is the method you use to return possible completions for the textfield's currently entered string. The array of strings you give will automatically be sorted in order of closest match to the user's entered string.

3) (Optional) Set the textfield's "autoCompleteDelegate" property to a valid object that implements the methods of the MLPAutoCompleteTextFieldDelegate protocol for further customization options.

You should now have a working MLPAutoCompleteTextField at this point. 


Notes
---------
Traditionally, you might have seen something similar to the MLPAutoCompleteTextField implemented with something like a "search tableview controller". This approach has some limitations which MLPAutoCompleteTextField has strived to overcome. 

The MLPAutoCompleteTextField sorting of autocomplete strings is powered by the NSString+Levenshtein category extension written by Mark Aufflick (based loosely on a Levenshtein algorithm written by Rick Bourner). This algorithm basically calculates the edit distance between two strings (the number of changes required to turn one string into the other).

When a datasource passes an array of strings to an MLPAutoCompleteTextField, the textfield sorts the strings according to edit distance and displays this list of autocomplete suggestions.

Used responsibly, we hope the MLPAutoCompleteTextField will open up new design possibilities for developers of all origins and skill levels. 

:D

Performance
---------
MLPAutoCompleteTextField uses a multi-threaded approach to it's sorting of autocomplete strings so that the main thread is never blocked and the UI stays 100% responsive. 

Keep in mind that although you can pass an ungodly amount of strings in an array to the MLPAutoCompleteTextField at once, performance will suffer directly related to the number of strings you give (we're talking on the magnitude of thousands of strings). If performance is suffering, you should find ways to reduce the amount of strings you pass to the MLPAutoCompleteTextField when it asks you for them. (For example, if you assume a user will always know the first letter of a word correctly, you may choose to only send an array of words that start with that letter or close to that letter on the keyboard, rather than every single possible word you have). 


Known Issues
----------
-Clear Color or Translucent textfields are a bit ugly at the moment.

-hide your autocomplete tableview (if its open) before rotating the view it's in, and then unhiding after the rotation is done.


What to Expect in Future Updates
-----------

-Weighted Suggestions: In some cases, there may exist multiple autocomplete strings that are all equally possible completions for the current entered incomplete string. In current versions, the user will simply have to keep typing a few more characters to further narrow down the autocomplete suggestions to float the most probable string to the top of the autocomplete list.

However, in the future you can expect to see a sort of "weighting" or "ranking" system, which will allow you to favor some strings over others by assigning a number to them. Strings with higher weight will appear closer to the top of the list of autocomplete suggestions. So even though a group of strings are all equally possible completions for a given incomplete string, the ones with higher weight are deemed as being the "more probable" matches and will be sorted accordingly. 

This should further reduce the number of characters a user has to type. 


-String Hiding: If an autocomplete suggestion is of such poor quality that it has nothing in common at all with the user's currently entered string, then there may be a built in option to not display this suggestion at all. 

-Tokenized Bolding: If a user has entered a string such as "Grate White Sha", and there is an autocomplete suggestion called "Great White Shark", then in the suggestion the word "Great" should be in bold, the word "White" should be regular, and the work "Shark" should have the "rk" bolded. This behaves more like Google's autocomplete. (A user can choose the reverse behavior too).


Credits
---------

MLPAutoCompleteTextField was written by Eddy Borja, at Mainloop LLC.

NSString+Levenshtein category extension was written by Mark Aufflick. 

If you make use of MLPAutoCompleteTextField, tell us about it! 
Feel free to leave comments, likes, hatemail, etc at hello@mainloop.us

