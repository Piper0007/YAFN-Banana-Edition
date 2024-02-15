## Error Handling
### General (Issues that are not specific or are not handled)
Issue: Not being able to get on a stage or open settings
Solution: Check output log for errors/warnings

Issue: Song not starting when pressing start
Solution: The output log will show yellow text (which is a warning) explaining why the song did not start

Error: “JSON file could not be decoded”
Solution: This happens whenever a chart has an extra comma or is missing some text, the method to fix it would be going into an application that reads JSON files and see where the error occurred.
