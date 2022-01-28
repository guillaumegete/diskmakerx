global MymacOSFileExtension
global macOS_App
global macOS_DMG
global macOSisFound


---- We create a Log file. Might be useful in the future…
--
set HomeFolder to quoted form of (do shell script "echo $HOME")

--
set LogPath to HomeFolder & "/Library/Logs/DiskMakerX.log"
tell me to do shell script "touch " & LogPath
tell me to do shell script "echo '--------------------------------------------------------------------------------' >> " & LogPath
tell me to do shell script "date >> " & LogPath
tell me to do shell script "echo 'Home Path: ' " & HomeFolder & ">> " & LogPath

-- Get the language.

try
	set lang to do shell script "defaults read NSGlobalDomain AppleLanguages"
	tell application "System Events"
		set LanguageList to make new property list item with properties {text:lang}
		set MyLanguage to value of LanguageList
	end tell
	set MyLanguage to item 1 of MyLanguage
	tell me to do shell script "echo 'Current Language: ' " & MyLanguage & ">> " & LogPath
end try

set ContinueButtonLoc to localized string of "Continue"

-- Version of DiskMaker X

set CurrentLDMVersion to "900"

set DebugMode to false

set LDMIcon to path to resource "diskmakerx.icns" in bundle (path to me)



set CurrentOS to do shell script "sw_vers -productVersion | cut -c 1-4"

set ShortOS to do shell script "sw_vers -productVersion | cut -c 4-4" as string


-- The cut command is sometimes too short. And "10.1" may not run on Intel Mac so… :-)

if CurrentOS is "10.1" then
	set CurrentOS to do shell script "sw_vers -productVersion | cut -c 1-5"
	set ShortOS to do shell script "sw_vers -productVersion | cut -c 4-5" as string
end if

tell me to do shell script "echo 'Current OS: ' " & CurrentOS & ">> " & LogPath
set ShortOS to ShortOS as integer



-- Alert if running on OS smaller than 10.7

if ShortOS is less than 10 then
	set NotmacOS106CompatibleLoc to localized string of "Sorry! DiskMaker X won't work with your version of macOS. Upgrade to macOS 10.10 or later before using DiskMaker X."
	set QuitButtonLoc to localized string of "Quit"
	set MoreInfoButtonLoc to localized string of "More information"
	display dialog NotmacOS106CompatibleLoc buttons {QuitButtonLoc, MoreInfoButtonLoc} default button 2 with icon path to resource "diskmakerx.icns" in bundle (path to me)
	set the button_pressed to the button returned of the result
	if button_pressed is MoreInfoButtonLoc then
		open location "http://diskmakerx.com/?page_id=28"
	else
		return
	end if
	return
end if

-- Alert if running 10.7 or 10.8 : no notification will be displayed

if ShortOS is "10.7" or ShortOS is "10.8" then
	if ShortOS is "10.7" then
		set macOSName to "Mac OS X"
	else
		if ShortOS is "10.8" then
			set macOSName to "OS X"
		end if
	end if
	
	set NotNotificationCompatible1Loc to localized string of "You are currently running "
	set NotNotificationCompatible2Loc to localized string of ". DiskMaker X won't be able to display notifications of current progress, but your Install disk should be built correctly."
	
	set NotificationDisplayed to false
	
	display dialog (NotNotificationCompatible1Loc & macOSName & " " & ShortOS & NotNotificationCompatible2Loc) buttons ContinueButtonLoc default button 1 with icon path to resource "diskmakerx.icns" in bundle (path to me)
else
	set NotificationDisplayed to true
end if






(*************************************************
***    Strings declarations to allow localization        ********
*************************************************)


-- Update dialog

set DialogUpdate1Loc to localized string of "A newer version of DiskMaker X is available. Do you want to download it?"
set NotNowThanksLoc to localized string of "Not now, thanks"
set GetNewVersionLoc to localized string of "Get new version"

-- Welcome Dialog

set WelcomeLoc to localized string of "Welcome to DiskMaker X!"
set MyWhichmacOSVersion to localized string of "Which version of macOS do you wish to make a boot disk of?"


-- Copy found dialog

set AcopyofmacOSwasfoundinfolderLoc to localized string of "I found a copy of the installer software in this folder:"
set DoyouwishtousethiscopyLoc to localized string of "Do you wish to use this copy?"


set MyUseAnotherCopy to localized string of "Use another copy…"
set MyUseThisCopyLoc to localized string of "Use this copy"


-- Some standard buttons

set QuitButtonLoc to localized string of "Quit"
set CancelButtonLoc to localized string of "Cancel"


-- No installer found dialog

set LDMDiskDetectedLoc1 to localized string of "I detected that the following disk was already built with DiskMaker X:"
set LDMDiskDetectedLoc2 to localized string of "Do you want to use it to build your new install disk ? WARNING: the disk will be completely erased!"

set MyCouldNotFoundInstallmacOSAppLoc to localized string of "No macOS Catalina Installer application could be found. Click on Select a macOS Installation App and choose the macOS Catalina Installer application."


set ChoosemacOSFileLoc to localized string of "Select a macOS Installation App…"
set ChoosemacOSFilePrompt1Loc to localized string of "Select the Installation app for "


set MyCheckTheFaq to localized string of "Check the FAQ"
set MyCreateTheUSBDrive to localized string of "To create a boot disk, please connect a USB, FireWire disk or insert an SD-Card (16 GB minimum). Then click on Choose the disk."

set MymacOSDiskIsReadyLoc to localized string of "Your macOS boot disk is ready! To use it, reboot your Mac and press the Option (Alt) key, or select it in the Startup Disk preference."
set MyMakeADonationLoc to localized string of "Make a donation"
set MyWebSite to localized string of "http://diskmakerx.com/"
set WannaMakeADonation to localized string of "If you enjoyed using DiskMaker X, your donations are also much appreciated."
set StartupPrefLoc to localized string of "Open Startup Disk Preference"

-- Error dialog

set MyDiskCouldNotBeCreatedError to localized string of "The disk could not be created because of an error: "
set MyAnErrorOccured to localized string of "An error occured: "
set MyUseThisDisk to localized string of "Use this disk"
set MyEraseAndCreateTheDisk to localized string of "Erase then create the disk"

-- Kind of physical disk dialog 

set WhichKindOfDiskYouUseLoc to localized string of "Which kind of disk will you use?"
set WhichKindOfDiskExplainationLoc to localized string of "If you have a 16 GB USB thumb drive, it will be completely erased. If you choose another kind of disk, ONLY the chosen volume will be erased. Your other disks and volumes will be left untouched."
set ProTipLoc to localized string of "PRO TIP: If you wish to build a multi-installations disk, use Another kind of disk each time, and choose a different partition for each OS you want to make a boot disk for!"
set WhichKindOfDiskIsUSB8GBLoc to localized string of "A 16 GB USB thumb drive (ERASE ALL DISK)"
set WhichKindOfDiskIsAnyOtherDiskLoc to localized string of "Another kind of disk (erase only partition)"


-- Last alert dialog

set LastAlertMessageLocVolume to localized string of "WARNING ! THE WHOLE CONTENTS OF THIS VOLUME WILL BE ERASED!"
set LastAlertMessageLocDisc to localized string of "WARNING: THE WHOLE CONTENT OF THE DISK (AND EVERY OTHER VOLUME OF THIS DISK) WILL BE ERASED!"
set LastAlertPart1Loc to localized string of "You are about to erase the volume : "
set LastAlertPart2Loc to localized string of "If you continue, all the data on it will be lost. Are you sure you want to do this ?"
set LastAlertPart3Loc to localized string of "The following volumes are on the same disk and will be erased:"

-- Alert for Mavericks

set AdminAlertLoc to localized string of "You will be required to type your login and password soon."

set AdminAlertTitleLoc to localized string of "The next step will ask for administrator privileges to build the install disk, so please type your administrator login and password when necessary."


-- Can't use this disk dialog

set MyNotTheCorrectmacOSFileLoc to localized string of "This file can't be used to create an OS X Installation disk."

-- Can't eject disk Dialog

set CantEjectDiskLoc to localized string of "Sorry, I can't eject the following volume :"
set PleaseEjectAgainLoc to localized string of "Please eject it and try again."

-- Disk selection dialog

set HereAreTheDisksLoc to localized string of "Here are the disks you may want to use to create your boot disk"
set ChooseDiskToErase to localized string of "Please choose the disk you wish to erase"
set ChooseThisDiskLoc to localized string of "Choose this disk"


-- Miscellanous localizations

set MyCantUseThisDisk to localized string of "This disk can't be used because it is not a removable disk."
set ChooseDiskToEraseLoc to localized string of "Please choose the disk you wish to erase"


-- No disk available alert

set NoDiskAvailableLoc to localized string of "Sorry, I can't find a disk to use… Please plug a disk, then relaunch DiskMaker X."

-- Icon Error Management

set IconError1Loc to localized string of "Sorry, I could not get the icon to personnalize the disk. Don't worry, your macOS disk will work fine."
set IconError2Loc to localized string of "I will leave a copy of the compressed icon named "
set IconError3Loc to localized string of ".zip on your Desktop so that you can still personnalize the disk yourself."
set IconError4Loc to localized string of "Check the FAQ on the web site for more info."




set AlreadyALDMDiskLoc to localized string of "The following volume has already been used as a bootable install disk. Do you want DiskMaker X to use it ? Its content will be completely erased."
set AlreadyALDMDiskConfirmLoc to localized string of "Update this volume"
set AlreadyALDMDiskCancelLoc to localized string of "Use another volume"

set CopyingFilesLoc to localized string of "Copying files…"

set MyPaypalLoc to localized string of "http://diskmakerx.com/donations/"

set MoreInfoButtonLoc to localized string of "More information"
set DMGIncompleteLoc to localized string of "Sorry, your macOS Install app may be incomplete. Delete your install application, then download it again from the App Store."


set OpenAppStoreLoc to localized string of "Open App Store"

set DarkModeBackgroundDialogLoc to localized string of "Last question: would you rather go dark?"
set GoDarkLoc to localized string of "I want to come to the Dark side!"
set GoLightLoc to localized string of "I'm more in a light mood."

-- Path to sound resource

set SoundPath to ((path to resource "Roar.mp3"))

set MySupportSite to "http://diskmakerx.com/faq/"

-- We check if the application is running in an admin session. If not, it's not necessary to go further…

set YouAreNotAdminLoc to localized string of "Sorry, DiskMaker X requires to be run in an admin session. Please switch to an admin session, then launch DiskMaker X again."

set imadmin to "80" is in (do shell script "id -G")

tell me to do shell script "echo 'Is this user an admin : ' " & imadmin & ">> " & LogPath


if imadmin is false then
	display dialog YouAreNotAdminLoc buttons QuitButtonLoc default button 1
	return
end if


-- Check for Path Finder presence. It's not recommended to use it when using DiskMaker X.

set PathFinderOpenLoc to localized string of "Sorry, DiskMaker X is not compatible with Path Finder. Please quit Path Finder, relaunch the Finder if necessary, then run DiskMaker X again."

set PathFinderLaunched to "Path Finder" is in (do shell script " ps auxc")
tell me to do shell script "echo 'Path Finder launched : ' " & PathFinderLaunched & ">> " & LogPath

if PathFinderLaunched is true then
	display dialog PathFinderOpenLoc buttons QuitButtonLoc default button 1
	
	return
end if


-- Check if a new version is available.

try
	with timeout of 3 seconds
		set LatestDMXVersion to do shell script "curl http://diskmakerx.com/CurrentLDMVersion" as string
		if LatestDMXVersion is greater than CurrentLDMVersion then
			
			display dialog DialogUpdate1Loc buttons {QuitButtonLoc, NotNowThanksLoc, GetNewVersionLoc} default button 3
			
			set ResultButton to the button returned of the result
			
			if ResultButton is GetNewVersionLoc then
				open location MyWebSite
				return
			else
				if ResultButton is QuitButtonLoc then
					return
				end if
			end if
		end if
	end timeout
end try



-- First, we ask which OS we want to deal with so that we can declare a few variables.




set First_DMG_Volume to "OS X Install ESD"
set Second_DMG_Volume to "OS X Base System"



-- Variables for macOS 10.15 Catalina

set macOSVersion to "10.15"
set OSFileName to "Install macOS Catalina"
set IconName to "Catalina.icns"
set DiskIconName to "CatalinaIcon1024"
set FinalDiskName to "macOS Catalina Install Disk"
set InstallDiskNameLoc to localized string of "macOS Catalina 10.15 Install"
set CreateInstallMediaDiskName to "Install macOS Catalina"
set DarkBackground to "DarkCatalinaBackground.jpg"
set LightBackground to "LightCatalinaBackground.jpg"


tell me to do shell script "echo 'Selected OS: ' " & macOSVersion & ">> " & LogPath

-- First I check if I can find the install app in the Applications folder.
-- I will use Spotlight only if it does not exist here.

set macOSisFound to "Not found yet"

tell application "System Events"
	if exists file ("/Applications/" & OSFileName & ".app/Contents/SharedSupport/InstallESD.dmg") then
		set macOS_DMG to "'/Applications/" & OSFileName & ".app/Contents/SharedSupport/InstallESD.dmg'"
		
		
		set macOS_App to quoted form of "/Applications/Install macOS Catalina Beta.app"
		
		set macOSisFound to "Found"
		
		
		tell me to do shell script "echo 'Install App Path: ' " & macOS_App & ">> " & LogPath
		
		
		display dialog (AcopyofmacOSwasfoundinfolderLoc & return & return & "/Applications" & return & return & DoyouwishtousethiscopyLoc) buttons {CancelButtonLoc, MyUseAnotherCopy, MyUseThisCopyLoc} default button 3 with icon path to resource IconName in bundle (path to me)
		set the button_pressed to the button returned of the result
		
		-- If it's not the right app, you may want to choose another app.
		
		if the button_pressed is MyUseThisCopyLoc then
			
			set macOS_DMG to quoted form of ("/Applications/" & OSFileName & ".app/Contents/SharedSupport/InstallESD.dmg")
			set macOSisFound to "Found"
			set macOS_App to quoted form of ("/Applications/" & OSFileName & ".app")
		else
			if the button_pressed is MyUseAnotherCopy then
				
				my theChoiceOfAnotherCopy(ChoosemacOSFilePrompt1Loc, OSFileName, MyNotTheCorrectmacOSFileLoc, CancelButtonLoc, LogPath)
				
			end if
			
			if the button_pressed is CancelButtonLoc then
				return
			end if
		end if
	end if
end tell


-- If we can't find in /Applications, then we use Spotlight

if macOSisFound is "Not found yet" then
	
	set OSSearch to (do shell script "mdfind -name '" & OSFileName & "' | grep -v Library | head -1")
	set OSSearchResultNumber to (do shell script "echo " & quoted form of OSSearch & " | wc -l ") as integer
	
	
	if OSSearch is not "" then
		
		set macOSFolder to OSSearch
		display dialog (AcopyofmacOSwasfoundinfolderLoc & return & return & macOSFolder & return & return & DoyouwishtousethiscopyLoc) buttons {CancelButtonLoc, MyUseAnotherCopy, MyUseThisCopyLoc} default button 3 with icon path to resource IconName in bundle (path to me)
		set the button_pressed to the button returned of the result
		
		if the button_pressed is MyUseThisCopyLoc then
			
			set macOS_App to quoted form of (POSIX path of macOSFolder)
			set macOS_DMG to quoted form of ((POSIX path of macOSFolder) & "/Contents/SharedSupport/InstallESD.dmg")
			
			
		else
			if the button_pressed is MyUseAnotherCopy then
				
				my theChoiceOfAnotherCopy(ChoosemacOSFilePrompt1Loc, OSFileName, MyNotTheCorrectmacOSFileLoc, CancelButtonLoc, LogPath)
			end if
			
			if the button_pressed is CancelButtonLoc then
				return
			end if
			
		end if
		
	else
		display dialog MyCouldNotFoundInstallmacOSAppLoc buttons {CancelButtonLoc, MyCheckTheFaq, ChoosemacOSFileLoc} default button 3 with icon caution
		
		set the button_pressed to the button returned of the result
		
		if the button_pressed is MyCheckTheFaq then
			open location MyWebSite
			return
		else
			if the button_pressed is ChoosemacOSFileLoc then
				
				my theChoiceOfAnotherCopy(ChoosemacOSFilePrompt1Loc, OSFileName, MyNotTheCorrectmacOSFileLoc, CancelButtonLoc, LogPath)
				
			end if
			
		end if
		
	end if
end if

(************************************************************************************************)

(*** We empirically test the size of the Install App's dmg, to be sure there's not an issue with it.
Currently the size of the installer for macOS Catalina is more than 7 GB.
***)



set InstallESD_DMG_Size to (do shell script "ls -la " & macOS_App & "/Contents/SharedSupport/InstallESD.dmg | awk  '{ print $5 }'") as integer

if InstallESD_DMG_Size is less than 7.0E+9 then
	activate
	display dialog (DMGIncompleteLoc & return & return) buttons {MoreInfoButtonLoc} default button 1 with icon path to resource IconName in bundle (path to me)
	set the button_pressed to the button returned of the result
	open location MySupportSite
	return
end if



(*********************          Creating a bootable disc           ***************************)


-- New routine checks if a file exists with a .LionDiskMaker_OSVersion hidden file at root. 

tell application "Finder"
	set DontEraseTheDisk to false
	set LDMAlreadyThere to false
	
	set TheNumberOfEjectableDisks to the number of (every disk whose (ejectable is true))
	
	try
		set TheEjectableDiskList to the name of (every disk whose (ejectable is true))
	on error
		display dialog NoDiskAvailableLoc buttons QuitButtonLoc default button 1
		return
		
	end try
	set n to 1
	
	repeat with loopVar from n to TheNumberOfEjectableDisks
		set MyDisk to (item n of TheEjectableDiskList)
		set HiddenFileToFind to "/Volumes/" & MyDisk & "/.LionDiskMaker_OSVersion" as string
		if exists HiddenFileToFind as POSIX file then
			set LDMAlreadyThere to true
			
			tell me to do shell script "echo 'Another DiskMaker X disk found: true' >> " & LogPath
			set NewVolumeName to MyDisk
			
			tell me to do shell script "echo 'Previous DiskMaker X disk name found: ' " & MyDisk & ">> " & LogPath
			
			set AlreadyLDMDisk to MyDisk
			set MyErasefullDisc to false
		end if
		
		set n to n + 1
	end repeat
end tell

if LDMAlreadyThere is true then
	activate
	display dialog LDMDiskDetectedLoc1 & return & return & AlreadyLDMDisk & return & return & LDMDiskDetectedLoc2 & return buttons {AlreadyALDMDiskCancelLoc, AlreadyALDMDiskConfirmLoc} default button 2 with icon path to resource IconName in bundle (path to me)
	set the button_pressed to the button returned of the result
	if the button_pressed is AlreadyALDMDiskConfirmLoc then
		set MyTargetDisk to AlreadyLDMDisk
		set MyTargetDiskPath to the quoted form of (POSIX path of MyTargetDisk)
		tell me to do shell script "echo 'Path to target: ' " & MyTargetDiskPath & ">> " & LogPath
	else
		set LDMAlreadyThere to false
		set MyErasefullDisc to false
	end if
end if


if LDMAlreadyThere is false then
	-- We have to know if the selected disk is a 16 GB thumbnail disk or something else to choose the proper way to erase the disk.
	activate
	display alert WhichKindOfDiskYouUseLoc message WhichKindOfDiskExplainationLoc & return & return & ProTipLoc & return & return buttons {CancelButtonLoc, WhichKindOfDiskIsAnyOtherDiskLoc, WhichKindOfDiskIsUSB8GBLoc} default button 3 as critical
	set the button_pressed to the button returned of the result
	if the button_pressed is WhichKindOfDiskIsUSB8GBLoc then
		set MyErasefullDisc to true
		
	else
		if the button_pressed is WhichKindOfDiskIsAnyOtherDiskLoc then
			set MyErasefullDisc to false
		else
			return
		end if
	end if
	
	tell me to do shell script "echo 'Erase Full Disk: ' " & MyErasefullDisc & ">> " & LogPath
	
	-- We have to define the list of disks available for use.
	
	
	tell application "Finder"
		if MyErasefullDisc is true then
			tell me to do shell script "echo 'Erase full Disk: True' >> " & LogPath
			try
				set ListOfDisks to the name of (every disk whose (ejectable is true) and (capacity is less than 1.45E+11))
			on error
				display dialog NoDiskAvailableLoc buttons {QuitButtonLoc} default button 1 with icon path to resource IconName in bundle (path to me)
				return
			end try
			set LastAlertMessageLoc to LastAlertMessageLocDisc
		else
			try
				tell me to do shell script "echo 'Current OS: ' " & CurrentOS & ">> " & LogPath
				
				set ListOfDisks to the name of (every disk whose (ejectable is true))
				
			on error
				display dialog NoDiskAvailableLoc buttons {QuitButtonLoc} default button 1 with icon path to resource IconName in bundle (path to me)
				return
			end try
			set LastAlertMessageLoc to LastAlertMessageLocVolume
		end if
	end tell
	
	set MyTargetDisk to choose from list ListOfDisks with prompt HereAreTheDisksLoc with title ChooseDiskToEraseLoc cancel button name CancelButtonLoc OK button name ChooseThisDiskLoc default items 1 without multiple selections allowed and empty selection allowed
	if MyTargetDisk is not false then
		set MyTargetDiskPath to the quoted form of (POSIX path of MyTargetDisk)
	else
		display dialog NoDiskAvailableLoc buttons {QuitButtonLoc} default button 1 with icon path to resource IconName in bundle (path to me)
		
		return
	end if
	
	-- We get all the volumes which are part of the same disk as our target volume. Just to let the user know… 
	
	set FullDiskName to last word of (do shell script "diskutil info /Volumes/" & quoted form of (MyTargetDisk as string) & " | grep 'Part of Whole'")
	
	-- And we get the full size of the disk. Necessary a bit later.
	-- thanks @lolopb who managed to find a way to workaround a bad limitation with diskutil in 10.6…
	
	if MyErasefullDisc is true then
		try
			set FullListOfDisks to do shell script "for (( i = 2; i <= $(diskutil list " & FullDiskName & " | tail -n 1 | cut -c 75-76); i++));  do diskutil info " & FullDiskName & "s$i | grep \"Volume Name: \" | cut -c 30-75; done | grep -v 'Recovery HD'"
			
			tell me to do shell script "echo 'List of volumes on same disk : ' " & FullListOfDisks & ">> " & LogPath
			
			
		on error errMsg number errNum
			set FullListOfDisks to ""
			set LastAlertPart2Loc to ""
			set LastAlertPart3Loc to ""
		end try
	else
		set FullListOfDisks to ""
		set LastAlertPart3Loc to ""
	end if
	
	-- Last Warning !!!	There's no turning back from here.
	
	display alert LastAlertMessageLoc message LastAlertPart1Loc & return & return & MyTargetDisk & return & return & LastAlertPart2Loc & return & LastAlertPart3Loc & return & return & FullListOfDisks buttons {CancelButtonLoc, MyEraseAndCreateTheDisk} default button 2 as warning
	
	set the button_pressed to the button returned of the result
	if the button_pressed is CancelButtonLoc then
		return
	end if
end if



-- Choose your Background picture. Absolutely, completely useless, so completely unmissable.

set DarkModeBackgroundDialogLoc to localized string of "Last question: would you rather go dark?"
set GoDarkLoc to localized string of "I want to come to the Dark side!"
set GoLightLoc to localized string of "I'm more in a light mood."


display dialog DarkModeBackgroundDialogLoc buttons {GoLightLoc, GoDarkLoc} default button 1 with icon path to resource IconName in bundle (path to me)
set the button_pressed to the button returned of the result
if the button_pressed is GoDarkLoc then
	set macOSBackground to DarkBackground
else
	set macOSBackground to LightBackground
end if



display alert AdminAlertTitleLoc message AdminAlertLoc buttons {CancelButtonLoc, ContinueButtonLoc} default button 2 as warning


-- Disk creations begins ! --



-- We use uuidgen to warrant a unique name to the disk (avoiding to erase other drives in the process…)
if DontEraseTheDisk is false then
	
	set NewVolumeName to (do shell script "uuidgen")
	
	-- To avoid errors, we check that the disk is really ejectable.
	
	set IsEjectable to do shell script "diskutil info " & MyTargetDiskPath & " | grep -i \"Ejectable\" | awk '{ print $2}' "
	if IsEjectable is "No" then
		
		tell me to do shell script "echo 'No ejectable disk !'>> " & LogPath
		
		display dialog MyCantUseThisDisk with icon stop
		
	else
		
		
		-- ADD LOCALIZATION HERE
		
		display notification "Erasing drive " & MyTargetDiskPath & "…"
		
		
		if MyErasefullDisc is true then
			tell me to do shell script "echo 'Target Disk Path: ' " & MyTargetDiskPath & ">> " & LogPath
			tell me to do shell script "echo 'New Volume Name: ' " & NewVolumeName & ">> " & LogPath
			
			tell me to do shell script "diskutil partitionDisk $(diskutil info " & MyTargetDiskPath & " | grep -i \"Part Of Whole\" | awk '{ print $4}') 1 GPT jhfs+ " & NewVolumeName & " R"
		else
			tell me to do shell script "diskutil eraseVolume JHFS+ " & NewVolumeName & " " & MyTargetDiskPath
		end if
		
	end if
end if

-- sometimes the volume is not mounted yet while the copy begins. We need to delay a bit...

delay 2


with timeout of 9999 seconds
	
	-- First, we unmount any occurence of the Base System and the OS X Install ESD disk. Just in case.
	
	try
		tell me to do shell script "hdiutil detach -force '/Volumes/" & Second_DMG_Volume & "'"
		delay 2
	end try
	
	try
		tell me to do shell script "hdiutil detach -force '/Volumes/" & First_DMG_Volume & "'"
		delay 2
	end try
	
	
	tell application "Finder"
		open disk NewVolumeName
		
		-- Total Finder can prevent the modification of windows, so this piece of code will not run if it is running . Thanks to Dj Padzenzky for this part.
		try
			«event BATFchck»
		on error
			set bounds of Finder window 1 to {1, 44, 503, 493}
			set sidebar width of Finder window 1 to 0
			set statusbar visible of Finder window 1 to true
			set current view of Finder window 1 to icon view
		end try
		
		
	end tell
	(*********************************************************************************************************************************)
	
	
	delay 1
	
	-- ADD LOCALIZATION HERE
	
	display notification "Restoring macOS on " & NewVolumeName & "…"
	
	-- We get the size of the InstallESD.dmg file as it takes the longest time to copy
	
	set InstallESD_DMG_Size to do shell script "ls -la " & macOS_App & "/Contents/SharedSupport/InstallESD.dmg | awk  '{ print $5 }'"
	
	
	tell me to do shell script "sudo " & macOS_App & "/Contents/Resources/createinstallmedia --volume /Volumes/" & NewVolumeName & " --nointeraction &> /tmp/createinstallmedia.log &" with administrator privileges
	tell me to do shell script "echo 'OS X App path: ' " & macOS_App & ">> " & LogPath
	tell me to do shell script "echo 'New Volume Name: ' " & NewVolumeName & ">> " & LogPath
	
	-- We reset the counter which will be used to display notifications 
	
	display notification "Now preparing your disk !" subtitle "We'll notify you of current progress…"
	
	
	delay 10
	set myPreviousPercentage to 0
	
	
	
	repeat with i from 1 to 9999999
		
		set CreateInstallMediaStatus to (do shell script "ps auxc | grep createinstallmedia | wc -l |  awk '{ print $1 }'")
		set CreateInstallMediaLog to (do shell script "tail -n 1 /tmp/createinstallmedia.log")
		set CheckIfDiskIsErased to (do shell script "tail -n 1 /tmp/createinstallmedia.log | grep '100%'  | wc -l | cut -c 8")
		
		
		delay 5
		
		
		if CheckIfDiskIsErased is "1" then
			set CreateInstallMediaLog to CopyingFilesLoc
		end if
		
		
		-- We check the current size of InstallESD.dmg
		try
			set CurrentInstallESD_DMG_Size to do shell script "ls -la '/Volumes/" & CreateInstallMediaDiskName & "/" & OSFileName & ".app/Contents/SharedSupport/InstallESD.dmg' | awk  '{ print $5 }'"
			if CurrentInstallESD_DMG_Size is not "" then
				set InstallESDPercentage to (CurrentInstallESD_DMG_Size / InstallESD_DMG_Size) * 100 as integer
				
				if ((InstallESDPercentage mod 5) is 0) and (InstallESDPercentage > myPreviousPercentage) then
					if InstallESDPercentage = 100 then
						display notification "Copy is done." subtitle "Percentage complete: " & InstallESDPercentage & "%"
					else
						display notification "Now copying data… Please wait." subtitle "Percentage complete: " & InstallESDPercentage & "%"
					end if
					
					delay 5
					set myPreviousPercentage to InstallESDPercentage
				end if
			end if
		end try
		
		
		-- Is createinstallmedia still running ?
		
		if CreateInstallMediaStatus is "0" then
			exit repeat
			
		end if
		
	end repeat
	
	
	
	
	
	----------- Mounting the DMG files -----------
	
	-- ADD LOCALIZATION HERE
	
	
	try
		
		-- We get the version number. We will use it to rename the USB disk properly later.
		-- And YES, OS name is hardcoded because escaping this stuff is just boring.
		
		set macOSImageVersion to do shell script "defaults read '/Volumes/Install macOS Catalina Beta/Install macOS Catalina Beta.app/Contents/SharedSupport/InstallInfo.plist' \"System Image Info\" | grep version | awk '{ print $3 }'  | tr -d '\"' | tr -d ';' "
		
		
		
		
		set QuoteCreateInstallMediaDiskName to quoted form of CreateInstallMediaDiskName
		
		-- This fixes a bug where the Install Disk was not visible in Startup Disk system Preference. Thanks to Eric Knibbe (@EricFromCanada) for the fix !
		try
			tell me to do shell script "touch /Volumes/" & QuoteCreateInstallMediaDiskName & "/mach_kernel"
			tell me to do shell script "chflags hidden /Volumes/" & QuoteCreateInstallMediaDiskName & "/mach_kernel"
		end try
		
		tell application "Finder"
			try
				set position of alias (CreateInstallMediaDiskName & ":" & OSFileName & ".app") to {693, 165}
			end try
			open disk CreateInstallMediaDiskName
			close front window
			open disk CreateInstallMediaDiskName
			set icon size of icon view options of front window to 128
			try
				set sidebar width of front window to 0
			end try
			set bounds of front window to {5, 5, 815, 455}
			
		end tell
		
		
		
		-- Apply background
		
		try
			set BackgroundImage to path to resource macOSBackground in bundle (path to me)
			set BackgroundImagePath to quoted form of (POSIX path of BackgroundImage)
			
			tell me to do shell script "cp " & BackgroundImagePath & " '/Volumes/" & CreateInstallMediaDiskName & "'"
			
		end try
		
		tell application "Finder"
			activate
			open disk CreateInstallMediaDiskName
			try
				set background picture of icon view options of front window to file macOSBackground of disk CreateInstallMediaDiskName
			end try
		end tell
		
		try
			tell me to do shell script "chflags hidden '/Volumes/" & CreateInstallMediaDiskName & "/" & macOSBackground & "'"
		end try
		
		
		-- We need to close and re-open the window to refresh position of icons. Known bug. Oh well…
		
		tell application "Finder"
			close front window
			delay 1
			open disk CreateInstallMediaDiskName
		end tell
		
	on error the error_message number the error_number
		set the error_text to MyAnErrorOccured & the error_number & ". " & the error_message
		display dialog MyDiskCouldNotBeCreatedError & error_text
		return
	end try
	
	-------------------------------------------------------------------------------------------
	-- Don't forget the custom icon ! 									--
	-------------------------------------------------------------------------------------------
	
	-- We copy the icon in the /tmp folder, otherwise AppleScript will complain that it won't be able to access the icon file inside the bundle. Oh well.
	
	with timeout of 9999 seconds
		
		set ZipIconPath to quoted form of ((POSIX path of (path to me) & "Contents/Resources/" & DiskIconName & ".zip"))
		
		try
			tell me to do shell script "cp " & ZipIconPath & " /tmp/"
		end try
		
		-- We could have used gzip or another command, but this was the only way to preserve the icon file on the picture.
		
		if ShortOS is greater than 9 then
			tell me to do shell script "open -a '/System/Library/CoreServices/Applications/Archive Utility.app' /private/tmp/" & DiskIconName & ".zip"
		else
			tell me to do shell script "open -a '/System/Library/CoreServices/Archive Utility.app' /private/tmp/" & DiskIconName & ".zip"
		end if
		
		delay 2
		
		try
			tell me to do shell script "killall -9 'Archive Utility'"
		end try
		
		-- We had to add some delay because SSDs may be too fast and not provide time to copy and paste the icon.
		
		delay 3
		
		try
			tell application "Finder"
				activate
				
				open information window of file ("private:tmp:" & DiskIconName & ".png") of startup disk
				
			end tell
			
			
			tell application "System Events"
				tell application process "Finder"
					tell front window
						keystroke tab
						delay 1
						keystroke "c" using command down
						keystroke "w" using command down
					end tell
				end tell
			end tell
			delay 1
			
			tell application "Finder"
				open information window of disk CreateInstallMediaDiskName
			end tell
			
			tell application "System Events"
				tell application process "Finder"
					tell front window
						delay 1
						keystroke tab
						delay 1
						keystroke "v" using command down
						delay 2
						
						keystroke "w" using command down
					end tell
				end tell
			end tell
			
			
			-- Too many icons errors with third-party utilities with decompression tools. In this case, we'll just leave the icon file on the Desktop.
			
		on error
			display dialog IconError1Loc & return & IconError2Loc & DiskIconName & IconError3Loc & return & return & IconError4Loc buttons ContinueButtonLoc
			tell me to do shell script "cp " & ZipIconPath & " ~/Desktop"
			
		end try
		
		tell application "Finder"
			try
				close window "tmp"
			end try
			
			-- We personnalize the disk name with OS version now
			
			try
				set CompleteDiskName to (InstallDiskNameLoc & " - " & macOSImageVersion)
				set name of disk CreateInstallMediaDiskName to CompleteDiskName
			end try
		end tell
		
		
		-- Let's delete the temporary icon.
		--
		try
			tell me to do shell script "rm -f /tmp/" & DiskIconName & ".png"
			tell me to do shell script "rm -f /tmp/" & DiskIconName & ".zip"
		end try
		
		-- We create an invisible file with OS Version in it. Useful to re-use the disk rapidly.
		
		tell me to do shell script "echo " & macOSImageVersion & "  &> " & quoted form of ("/Volumes/" & CompleteDiskName) & "/.LionDiskMaker_OSVersion"
		
		
		
	end timeout
	
	(********************************************************************
			*********************                  VICTORY !                      ******************** 
			********************************************************************)
	
	
	with timeout of 9999 seconds
		
		
		-- Roar ! :)
		
		
		try
			tell me to do shell script ("afplay " & (quoted form of POSIX path of SoundPath))
			tell me to do shell script "echo 'Roar !'>> " & LogPath
			
		end try
		
		
		
		-- Display final dialog
		try
			tell me to activate
		end try
		
		display dialog MymacOSDiskIsReadyLoc & return & return & WannaMakeADonation buttons {QuitButtonLoc, StartupPrefLoc, MyMakeADonationLoc} default button 3 with icon path to resource IconName in bundle (path to me)
		set the button_pressed to the button returned of the result
		if the button_pressed is MyMakeADonationLoc then
			open location MyPaypalLoc
			return
		else
			if the button_pressed is StartupPrefLoc then
				tell me to do shell script "open   '/System/Library/PreferencePanes/StartupDisk.prefPane'"
			end if
		end if
		
	end timeout
	
end timeout

-- End of the choice of method to create the disk --



---------------------------------------------------------------------------------------
------------------------------------- HANDLERS ------------------------------------
---------------------------------------------------------------------------------------


-- RemoveTheCrubs Handler

on RemoveTheCrubs()
	try
		tell me to do shell script "rm /tmp/rsyncldm.log"
	end try
	try
		tell me to do shell script "killall -9 rsync"
	end try
	delay 2
	
	
end RemoveTheCrubs

-- Handler to manually choose an OS X install app or DMG.

on theChoiceOfAnotherCopy(ChoosemacOSFilePrompt1Loc, OSFileName, MyNotTheCorrectmacOSFileLoc, CancelButtonLoc, LogPath)
	set MymacOSFile to (choose file with prompt ChoosemacOSFilePrompt1Loc & OSFileName)
	
	tell application "Finder"
		set MymacOSFileExtension to name extension of MymacOSFile
	end tell
	
	if MymacOSFileExtension is "app" then
		set macOS_App to quoted form of ((POSIX path of MymacOSFile))
		set macOS_DMG to quoted form of ((POSIX path of MymacOSFile) & "/Contents/SharedSupport/InstallESD.dmg")
		set macOSisFound to "Found"
		tell me to do shell script "echo 'Install App Path: ' " & macOS_App & ">> " & LogPath
	else
		display dialog MyNotTheCorrectmacOSFileLoc buttons {CancelButtonLoc} with icon stop
		return
	end if
	
	
end theChoiceOfAnotherCopy



