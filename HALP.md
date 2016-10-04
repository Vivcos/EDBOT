# **PAL's Halp System**

In this first major update to PAL, we're introducing a help system that lets us create a knowledgebase on specific topics. This is most useful for storing FAQ's about the game, community, ~~your grocery list~~, or any other important information / universal advice.

- Users (with certain privilege) will be able to create Help Entries.
- These entries can be searched through and recalled to the chat.
- Help Entries are *channel specific* by default; meaning they can only be displayed, modified, and otherwise interacted with in the channels they were created in.
- Help Entries have two main components: a key (i.e., title), and content. We also store the author of the entry, and the time it was created.
- You can make multiple entries with the *same* key, and recalling that key to the chat will display both entries.
- Every entry has a unique ID it can be referenced by.

## Command Spec

*All commands are prefixed with `pal.`*

**A `key` must be one word, with no spaces.** Recommended convention is `broad_topic/specific_topic/super_specific_topic/etc..`, but it can be anything you like.

|command | action  | permission level | example|
|---|---|---|---|
|`halp? [key]` | recall a help entry with matching `key` | `member` | `pal.halp? powerplay/undermining`|
|`halp# [ID]`| recall a specific help entry by ID | `member` | `pal.halp# 12` |
|`halp! [key] [text]` | creates a new help entry with `key` and `text`| `member` | `pal.halp! powerplay/undermining Undermine a system by doing xyz..`|
|`halp* [ID]` | deletes a help entry by ID | `moderator` | `pal.halp* 12`|
|`halp?? [ID]` | shows information (metadata) about the entry with `ID` | `member` | `halp?? 5`|
|`halp~ [ID] [text]` | replaces the contents of a help entry with `ID` and `text` | `author` | `pal.halp~ 12 No, you *actually* undermine by doing abc..`|

## Help Entry Metadata

|column | description|
|---|---|
|`id` | the ID of the entry|
|`timestamp` | the time it was created|
|`author_id` | the author id of the entry|
|`author_name` | the author name of the entry|
|`key` | the key of the entry|
|`text` | the text (contents) of the entry|
|`channel_id` | the ID/name of the channel its bound to|
