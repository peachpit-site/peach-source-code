## Peach source code




#### Setup

Peach is written using the Free Pascal / Lazarus system, downloadable [here](https://sourceforge.net/projects/lazarus/).

The Peach project.zip file should contain everything you need. To see the main program, open Peach project/main source code/Peach.lpi. To see the launcher, open Peach project/launcher source code/Peach.lpi.

Note that the launcher won't work until you've compiled the main program, since this is what the launcher launches.


#### Directory structure

The directories main source code and launcher source code have self-explanatory names. Beside this there is a folder called Peach, which contains the launcher (Peach.exe), some dlls, and  another directory, also called Peach.

This inner folder contains the main executable, also called Peach.exe and the following directories:

- Grammar plugins : the user-accessible folder for keeping .grm files in.
- Installation : this is where the Publish feature of Peach outputs setup files.
- Internationalization : where we keep the .lng files.
- Licenses : the license for Peach and the full text of the licenses for the auxiliary programs.
- Resources : all the bits Peach needs. This will be cataloged separately below. Invisible to the end-user.
- Vocab lists : the user-accessible folder for keeping .vcb files in.
- Workspace and Workspace 2 : these are folders used by the Publish feature and the updater, and are invisible to the end-user.

See the section on "file types" below for an explanation of .grm, .lng, and .vcb files.

The Resources directory has the following subdirectories:

- Balabolka : Contains the Balabolka utility for using SAPI5 voices.
- eSpeak NG : An alternative way of making Peach talk.
- File transfer : A folder which exists because I haven't learned how to use pipes yet.
- Icon : The icon to be used by this version of Peach.
- Inno setup : This is used by the Publish feature to produce the setup.exe file.
- Py files : A store for files produced by inserting .grm files into Sybil.
- Python : Literally Python.
- Rsc files : Files that store the state of Peach when it's shut down.
- Settings scheme : Contains a file which specifies the exact structure of the "Settings" section of a .vcb file
- Syntax checker : Contains a Python program for detecting syntax errors in Python programs, for the use of the grammar editor.


#### Units and packages

A review of the various units, plus packages and attendant files, in
alphabetical order. Unless otherwise indicated by a suffix each item is a unit.

When I say something is a "dialog" I mean that it hardly contains any code of
its own, but just collects data to be handled by code in the Main unit; when
I call it a "form", I mean that it handles its input itself.

■ AppearanceOptions : Supplies a dialog to pick the appearance options.

■ AppLanguage : Contains the "application language", that is, the language on
  the menus and message boxes and so forth — plus various functions for
  handling this data and accessing it.

  I will refactor the code so that this is a class when I find out what the
  singleton design pattern is actually *for*.

■ AssignHomework : A form that lets teachers do that.

■ CommonStringFunctions : Useful string functions which aren't Peach-specific,
  that is, which aren't oriented around .vcb and .lng files.

■ IconUpdater : A cunning hack that allows the users to programmatically change
  the icon of an .exe file.

■ Internet : Implements all the internet transactions in a mass of copy-and-
  paste-and-slightly-modify functions. Should be refactored some time but it all
  works so it's not high on the list.

■ InterposerEdit : Subclasses TEdit as an interposer class to do some keyboard
  handling and keep the thing DRY.

■ Licenses : Dialog to display license information.

■ LockdownOptions : Dialog to let you pick the lockdown options.

■ Main : The logic for the main form, plus for all the dialogs you can
  access from the toolbar etc.

■ Publish : Dialog for selecting options for publishing Peach as a setup.exe
  file

■ PyMemo.pas : Used by PythonPackage.lpk. It provides the keyboard handling,
  syntax highlighting, etc, for the grammar editor.

  Some keyboard handling (the Peach-specific stuff, diacritics etc) are
  currently handled in the event handler of the memo, and so have their code in
  the Main unit.

■ PythonFunctions.pas : Code for doing stuff with Python, eventually I'll regroup
  all such code here.

■ PythonPackage.lpk : Uses PyMemo as described above. It requires the
  richmemo_design package.

■ QAUnit : This is the bit that asks the end-user questions and grades them. It
  is closely entangled with the Main unit: they are two forms in the hope that
  this is less confusing for the end-user but they're a pain in the neck for me.

■ Register : Dialog allowing end-users to register online.

■ RmInlinePicture : Used by RichMemo to do pictures, so there it is.

■ SearchAndReplace : Dialog for search and replace in the text and grammar
  editors.

■ SignIn : Dialog allowing users to sign in on line.

■ StudentClasses : Form allowing a student to manage their classes.

■ TeacherClasses : Form allowing a teacher to manage their classes.

■ TestResults : Form allowing a teacher to inspect the test results for their
  classes.

■ VersionSupport : Someone else's code, used to get the file version.

■ Vocab : Contains the data from the current .vcb file and functions for
  manipulating and accessing it.

■ WMemo.pas : Used by WordMemo.lpk to provide much of the keyboard handling
  and text markup for the memos on the main screen, text editor, settings
  editor, etc.

■ WordMemo.lpk. Uses WMemo as described above. It requires the
  richmemo_design package.         


#### File types

Peach's exchangable data comes in three kinds, all of them basically utf-8
text files:

■ .grm files. These are the "grammar plugins" consisting of fragments of
  the Python scripting language.

■ .lng files. These are text files containing the "application language".
  Peach interprets it as follows: any paragraph having a colon with a space
  on either side of it is interpreted as a key-value pair. A paragraph that
  doesn't is interpreted as a comment.

■ .vcb files. These have the following format:

  A line beginning with a § is a topic heading.
  A line beginning with a ¶ is paragraph text, to be displayed to the end-
  user as-is (apart from the ¶).
  A line with neither is "live data", containing either of a vocabulary entry
  (in the main body of the file) or an editable setting in the Settings
  section, which I should now explain.

  The main body of a .vcb file consists of text and vocabulary, arranged in
  topics in the format described above, e.g:

        §French numbers
        ¶
        ¶Here are some French numbers for you to learn:
        ¶
        un — one
        deux — two
        trois — three
        ¶
        §French colors
        ¶
        ¶Here are some French colors for you to learn:
        ¶
        rouge — red
        .
        .

  ... and so on.

  However, the topics 0 .. 9 form a header to the file, invisible to the end-
  user, telling Peach how to interact with the file. Here is a quick summary of
  what they contain, together with the name of the constant Peach uses to refer
  to each of them.

0. seSettingsHeader : Contains nothing but a topic heading saying Settings, for my convenience.
1. seLangNames : The names of the languages, the direction they're written in, and info for getting audio.
2. seAboutVlist : A help message for when the end-user goes to Help and asks to be told about the specific .vcb file they're using.
3. seKeysHelp : A help message for the keyboard settings.
4. seLang1Keys : Keyboard settings for language 1.
5. seLang2Keys : Keyboard settings for language 2.
6. seQuestionFormats : Formats for asking the end-user questions.
7. seTestOverrides : Override the user's choices in the Options menu.
8. seAppearanceOverrides : Ditto
9. seLockdownOverrides : Ditto

  Much of the text in the Settings section, including all of the topic headings,
  consists of tokens to be translated in the light of an .lng file.
