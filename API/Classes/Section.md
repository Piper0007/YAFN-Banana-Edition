# Section

## Description
A class that stores specific information about a section. Such as if the camera focuses on BF or Dad, the notes, the length, and the type of section.
## Properties
| Name : Type | Description |
|-------------|-------------|
| mustHitSection : boolean | Value is true if the section is focused on BF and false if it is focused on Dad |
| typeOfSection : number | Determines the amount of beats per section, Default: 4 |
| lengthInSteps : number | Determines the length in steps that section is, Default: 16 |
| sectionNotes : [Note](Note.md)[] | Includes a list of notes for the current section |
