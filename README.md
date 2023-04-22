![GitHub top language](https://img.shields.io/github/languages/top/mlibby/PiggyBank)
[![License](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](./LICENSE)

# Welcome to PiggyBank

PiggyBank is a project to create a household financial appliance. As an appliance, PiggyBank is more than just an app.

Traditional accounting software is a single-user app, which is hard (if not impossible) for families or groups to share. The app and the data live on just one computer and there's no mechanism for safely sharing it with someone using another computer, even on the same network.

Newer accounting software solves this problem by running everything in "the cloud". But the cloud isn't some sort of magical place, it's  someone else's computer. So now you can share your data with someone else in your household, but you're also sharing it with anyone who has access to that "cloud" computer.

PiggyBank is an appliance that resolves this conflict by bringing "the cloud" a little closer to home. You install PiggyBank on a computer on your home network or LAN. Then you access your data from any computer attached to your LAN by visiting PiggyBank in your web browser. You could access it from a laptop, a PC, tablet, or phone-- probably even a smart TV that has a web browser.

If you want to make PiggyBank an _actual_ home appliance, I have a 3D printable piggybank shaped case that houses a Raspberry Pi and small computer (touch) screen. Then you have an interactive piggybank that can give you an always-on status report of how you're doing.
     

# Status and TODO List

Right now, PiggyBank is still in the very early stages of development, having been through a few "rough draft" phases. The first application I wrote I called "Fiscal Bliss" and I made the mistake of not just using the standard double-entry book-keeping model, instead opting for something I thought would be easier. It was not. And I wasn't able to figure out a migration path to it once I realized that I had erred and ran into limits. So I went for a rewrite. And failed.

Then I thought I would write it in [insert a long list of programming languages] here. But I would run into friction and think "well, let's try [other language/framework]" and then I was on a cycle of analysis paralysis. Then I hit a burnout period as a software developer and spent almost two years writing no code outside of work. Now finally I've recovered from that, am feeling good about writing software again, and have decided that (for better or worse) that since I'm a .NET developer by day that it would be most productive to stick with what I know: C#, ASP.NET MVC, and SQL Server. Originally I'd pushed away from this stack because it was tied to Windows, but these days all of those things run on Linux (even if they are not yet 100% open source).

My first goal was to get PiggyBank to where it can import data from GnuCash (since that is the application I'm using for my personal finances until this is mature enough). I have the basic commodity, account, and transaction imports working directly against a GnuCash sqlite3 database.

My next goal is to build a budget tool that is more flexible and capable than what is available in GnuCash.

Once that's done, I expect to build Balance Sheet and Income Statement reports as web pages. This will have to include commodity price tracking for investment accounts before it's all done.

After that I'll work on getting PiggyBank to import QFX/OFX files downloaded from financial institutions.

# Full Documentation

Full documentation and a demo will eventually live at at [PiggyBankLive](https://piggybank.live).

# License

PiggyBank is copyright (C) 2023, Michael C. Libby

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

# Author

Michael C. Libby, [mlibby.com](https://mlibby.com)