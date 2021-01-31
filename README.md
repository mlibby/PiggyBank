![rake test](https://github.com/mlibby/PiggyBank/workflows/rake%20test/badge.svg)
![license: AGPL-3.0](https://img.shields.io/github/license/mlibby/PiggyBank)

# Welcome to PiggyBank

PiggyBank is a project to create a household financial appliance. As an appliance, PiggyBank is more than just an app.

Traditional accounting software is a single-user app, which is hard (if not impossible) for families or groups to share. The app and the data live on just one computer and there's no mechanism for safely sharing it with someone using another computer, even on the same network.

Newer accounting software solves this problem by running everything in "the cloud". But the cloud isn't some sort of magical place, it's really just someone else's computer. So now you can share your data with someone
else in your household, but you're also sharing it with anyone who has access to that "cloud" computer.

PiggyBank is an appliance that resolves this conflict by bringing "the cloud" a little closer to home. You install PiggyBank on a Raspberry Pi (or any computer, really) and put that system on your home network or LAN.

Then you can access your data from any computer attached to your LAN by visiting PiggyBank in your web browser. You could access it from a laptop, a PC, tablet, or phone-- probably even a smart TV that has a web browser.

If you want to make PiggyBank an _actual_ home appliance, there is a 3D printable piggybank case that houses a Raspberry Pi and small computer screen. It's an interactive piggybank that can give you an always-on status report of how you're doing.

A proof-of-concept demo is available at [PiggyBank@Heroku](https://piggybanklive.herokuapp.com)
     

# Status and TODO List

Right now, PiggyBank is still in the very early stages of development, having been through a few "rough draft" phases.

The first goal is to get PiggyBank to where it can track investments, keeping track of how many shares you have of a given investment and being able to download updated prices.

The next goal after that is to have PiggyBank be able to import QFX/OFX files downloaded from financial institutions.

# Full Documentation

Documentation lives at [PiggyBankLive](https://piggybank.live)

# License

PiggyBank is copyright (C) 2021, Michael C. Libby

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