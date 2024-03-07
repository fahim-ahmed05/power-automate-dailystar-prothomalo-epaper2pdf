# Download Prothom Alo & The Daily Star E-Paper as PDF

[![Static Badge](https://img.shields.io/badge/Join%20Telegram%20Group-Readers%20Club-blue)](https://t.me/+jTKFvw-_SXg0NzZl)

This Power Automate Flow is designed to automatically download [Prothom Alo](https://epaper.prothomalo.com/) & [The Daily Star](https://epaper.thedailystar.net/) ePaper content as a PDF file using browser automation and PowerShell scripting. With this flow, you can streamline the process of fetching daily ePaper content and converting it into a PDF format for easier access and archival purposes.

## Setup

- Open Terminal/PowerShell.
- Type `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted` and press Enter.

**Install ImageMagick**
- Type `winget install ImageMagick.ImageMagick` and press Enter. Accept necessary permissions to install it.

**Install Microsoft Power Automate**
- Type `winget install 9NFTCH6J7FHV` and press Enter. 
- Accept necessary permissions to install it. 

**Create edge folder in C:\ePaper**
- Type `mkdir C:\ePaper\edge` and press Enter.
- Close terminal.

**Install Microsoft Power Automate Browser Extension**
- Open Microsft Edge Browser.
- Install the extension from [here](https://microsoftedge.microsoft.com/addons/detail/microsoft-power-automate/kagpabjoboikccfdghpdlaaopmgpgfdc).

**Login to The Daily Star ePaper**
- Click [here](https://epaper.thedailystar.net/) and login. If you don't have an account, create it! Make sure the ***remember me*** box is checked.

**Change Edge Browser Settings**
- Go to Edge Browser Settings and change default download location to `C:\ePaper\edge`.
- Also turn off ***Ask me what to do with each download***.
- Close browser.

**Create Microsoft Power Automate Flow**
- Open Microsoft Power Automate Program.
- Login with a Microsoft Account.
- Click on **New Flow** Button.
- Give the flow a name and click on create.
- Click [here](https://raw.githubusercontent.com/fahim-ahmed05/power-automate-dailystar-prothomalo-epaper2pdf/main/flow.txt), select everything using shortcut Ctrl+A, then copy using Ctrl+C.
- Click anywhere in the middle of the Power Automate window and paste copied text using Ctrl+V.
- Now Click Save.
- Close the flow window.
- Exit Power Automate.

## Run
- Open Microsoft Power Automate.
- Click on ***My flows***.
- Click on the ***Play button*** next to the flow name.
- When The Daily Star page opens, the flow will ask for the number of pages. Click on the ***drop down menu which has 1:Front*** written on it or check the left sidebar.
- Count total number of pages then input the number and click ***OK***.
- ***Make sure the first page is selected*** before you click ***OK***.
- Wait for the flow to end.
- A explorer window will open with downloaded ePapers.

## Note
- This is for windows only.
- Do not keep anything in `C:\ePaper\edge`. The flow will delete everything on run in this folder.
- Please follow setup instructions carefully.
- If you have any download manager extension installed on edge, such as IDM, ADM etc. Please disable it before running the flow.
- Edge Browser will show a popup to allow/deny ***Automatic downloads***. Allow it.
- Downloaded ePaper PDFs are will be in `C:\ePaper\output` folder.

## Support

For any inquiries, feedback, or support related to this Power Automate Flow, please message in this [telegram group](https://t.me/+jTKFvw-_SXg0NzZl).

## Donate
If you found this project helpful or useful, you can support my work by buying me a coffee.

<a href="https://www.buymeacoffee.com/fahim.ahmed" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>
