# Reservation slots: how they work

The **Pickup date** calendar on the website shows how many cakes Char can still take each day. The numbers come from a Google Sheet that Char updates on her phone. Changes appear on the website within about a minute.

Until a sheet is linked, the website uses Char's rules, set in `website/main.js` (the `SLOTS` settings): 4 cakes per day, order at least 4 days ahead, pickup on the hour from 8:00 AM to 5:00 PM, open every day.

## One-time setup (about 10 minutes)

1. Go to https://sheets.google.com and create a blank spreadsheet. Name it **Sweet Treats slots**.
2. Rename the first tab (bottom left) to **Settings**. Add a second tab named **Dates**. Spell both exactly like this.
3. Select everything on both tabs (click the corner box) and choose **Format → Number → Plain text**. This stops Google from changing dates and times.
4. Type the tabs as shown below. The first row of each tab is the header row.
5. Click **Share** → under General access choose **Anyone with the link** → **Viewer** → **Done**.
6. Copy the sheet link and send it to Claude. The long code between `/d/` and `/edit` is the Sheet ID. Claude puts it in `website/main.js` and publishes.

### Settings tab

| Setting | Value |
|---|---|
| Cakes per day | 4 |
| Order at least (days ahead) | 4 |
| Pickup times | 8:00 AM, 9:00 AM, 10:00 AM, 11:00 AM, 12:00 NN, 1:00 PM, 2:00 PM, 3:00 PM, 4:00 PM, 5:00 PM |
| Closed days | |

- **Cakes per day:** how many cakes Char can make on a normal day.
- **Order at least (days ahead):** the earliest pickup date is today plus this many days.
- **Pickup times:** separate them with commas. They show as buttons on the website.
- **Closed days:** weekdays Char never takes pickups, separated by commas. Leave it blank if she's open every day.

### Dates tab

Only add a row when a day changes. Days that aren't listed use the Settings.

| Date | Booked | Slots | Note |
|---|---|---|---|
| 2026-12-20 | 2 | | |
| 2026-12-24 | 1 | 5 | Christmas Eve: extra slots |
| 2026-12-25 | | | Closed |

- **Date:** type it as year-month-day, for example `2026-12-20`.
- **Booked:** how many cakes are already confirmed for that day. When it reaches the day's slots, the website shows **Full**.
- **Slots:** only fill this in to change that one day's limit. Leave it blank to use Cakes per day.
- **Note:** type **Closed** to block the day. Any other text shows under the date when a customer picks it.

## Day-to-day use

When Char confirms an order on Messenger, she opens the sheet and adds 1 to **Booked** for that date. If the date isn't listed yet, she adds a new row.

The website form doesn't take a slot by itself. A customer picking a date is only an inquiry until Char confirms it.

## The template files

`Settings.csv` and `Dates.csv` in this folder have the same layout. In Google Sheets you can use **File → Import → Upload** to load each one into its tab instead of typing.
