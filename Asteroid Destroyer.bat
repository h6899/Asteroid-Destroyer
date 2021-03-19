REM Copyright (C) 2014-2016, 2020-2021 h6899

@echo off
cd data
mkdir %appdata%\Asteroid_Destroyer
cls
color 0F
mode 80,40
set version=git
title Asteroid Destroyer %version%
setlocal EnableDelayedExpansion EnableExtensions
lib\bg maximize
lib\bg font 11
lib\bg cursor 0

set highScore=0
set key=^^!ERRORLEVEL^^!
set lifes=3
set points=0
set pointsTwo=0
set speed=8
set level
set save
set y=-64
lib\insertbmp /p:"gfx\background.bmp" /z:400

:title
	set /a y+=1
	lib\insertbmp /p:"gfx\logo.bmp" /x:0 /y:%y% /z:400
	if "%y%" == "0" goto menu
	goto title

:menu
	set inGame=0
	lib\insertbmp /p:"gfx\background.bmp" /z:400
	cls
	echo.
	echo.
	echo.
	echo.
	echo.
	lib\insertbmp /p:"gfx\logo.bmp" /z:400
	lib\cmdmenusel f1%f0 "Play" "Settings" "Help" "Quit"
	if %ERRORLEVEL% == 1 goto playerSelect
	if %ERRORLEVEL% == 2 goto settings
	if %ERRORLEVEL% == 3 goto help
	if %ERRORLEVEL% == 4 exit

:playerSelect
	lib\insertbmp /p:"gfx\background.bmp" /z:400
	lib\insertbmp /p:"gfx\logo.bmp" /z:400
	cls
	echo.
	echo.
	echo.
	echo.
	echo.
	lib\cmdmenusel f1%f0 "1 Player" "2 Player" "Back"
	if %ERRORLEVEL% == 1 set players=1
	if %ERRORLEVEL% == 2 set players=2
	if %ERRORLEVEL% == 3 goto menu

:difficultySelect
	lib\insertbmp /p:"gfx\background.bmp" /z:400
	lib\insertbmp /p:"gfx\logo.bmp" /z:400
	cls
	echo.
	echo.
	echo.
	echo.
	echo.
	lib\cmdmenusel f1%f0 "Easy" "Medium" "Hard" "Back"
	if %ERRORLEVEL% == 1 set saveDir=1 & set level=800
	if %ERRORLEVEL% == 2 set saveDir=2 & set level=600
	if %ERRORLEVEL% == 3 set saveDir=3 & set level=400
	if %ERRORLEVEL% == 4 goto playerSelect

:gamePrepare
	set save=%appdata%\Asteroid_Destroyer\%saveDir%
	for /f %%a in (%save%) do set %%a
	lib\insertbmp /p:"gfx\background.bmp" /z:400
	set /a xp1=50
	set /a yp1=50
	set /a xp2=150
	set /a yp2=50
	set ammo=5
	set ammoTwo=5
	set ready=0

:ready
	cls
	if "%ready%" == "5" goto positionSet
	lib\bg sleep 125
	lib\batbox /g 35 20 /c 0x0f /d "Ready"
	lib\bg sleep 125
	set /a ready+=1
	goto ready

:positionSet
	cls & call cls
	set /a x=%random% %% 600 + 1
	set /a y=%random% %% 400 + 32
	set z=0
	set multiplier=100
	set hitboxx=%x%
	set hitboxy=%y%
	set hitboxx2=%x%
	set hitboxy2=%y%

:gameCls
	cls
	if "%ammo%" == "6" set ammo=5
	if "%ammoTwo%" == "6" set ammoTwo=5

	lib\insertbmp /p:"gfx\background.bmp" /z:400
	if "%players%" == "1" echo   x%lifes%    x%ammo%      Score: %points%      High Score: %highScore%
	if "%players%" == "2" echo   x%lifes%    x%ammo%   x%ammoTwo%      P1: %points%      P2: %pointsTwo%
	lib\insertbmp /p:"gfx\life.bmp" /x:5 /y:0 /z:100
	lib\insertbmp /p:"gfx\bullet.bmp" /x:85 /y:0 /z:100
	if "%players%" == "2" lib\insertbmp /p:"gfx\bullet.bmp" /x:145 /y:0 /z:100

:gameLoop
	set /a hitboxx2+=2
	set /a hitboxy2+=2
	set /a z+=%speed%
	set /a multiplier-=1
	if "%ammo%" == "0" goto gameOver
	if "%ammoTwo%" == "0" goto gameOver
	if "%multiplier%" == "0" set multiplier=1
	if "%lifes%" == "0" goto gameOver
	if "%z%" == "%level%" set /a lifes-=1 & goto positionSet
	lib\insertbmp /p:"gfx\enemy.bmp" /x:%x% /y:%y% /z:%z%
	lib\insertbmp /p:"gfx\player_one.bmp" /x:%xp1% /y:%yp1% /z:200
	if "%players%" == "2" lib\insertbmp /p:"gfx\player_two.bmp" /x:%xp2% /y:%yp2% /z:200

	if %xp1% gtr 900 set xp1=0
	if %yp1% gtr 600 set yp1=0
	if %xp1% lss 0 set xp1=900
	if %yp1% lss 0 set yp1=600

	if %xp2% gtr 900 set xp2=0
	if %yp2% gtr 600 set yp2=0
	if %xp2% lss 0 set xp2=900
	if %yp2% lss 0 set yp2=600

	lib\bg _kbd
	if %key% == 32 if %hitboxx% lss %xp1% if %hitboxx2% gtr %xp1% if %hitboxy% lss %yp1% if %hitboxy2% gtr %yp1% lib\insertbmp /p:"gfx\explosion.bmp" /x:%x% /y:%y% /z:%z% & lib\bg sleep 100 & set /a points+=10*multiplier & set /a playerOne+=1 & set /a ammo+=1 & goto positionSet
	if %key% == 32 set /a ammo-=1 & goto gameCls
	if %key% == 327 set /a yp1-=50 & goto gameCls
	if %key% == 332 set /a xp1+=50 & goto gameCls
	if %key% == 330 set /a xp1-=50 & goto gameCls
	if %key% == 335 set /a yp1+=50 & goto gameCls
	if "%players%" == "2" if %key% == 113 if %hitboxx% lss %xp2% if %hitboxx2% gtr %xp2% if %hitboxy% lss %yp2% if %hitboxy2% gtr %yp2% lib\insertbmp /p:"gfx\explosion.bmp" /x:%x% /y:%y% /z:%z% & lib\bg sleep 100 & set /a pointsTwo+=10*multiplier & set /a playerTwo+=1 & set /a ammoTwo+=1 & goto positionSet
	if %key% == 113 set /a ammo-=1 & goto gameCls
	if "%players%" == "2" if %key% == 119 set /a yp2-=50 & goto gameCls
	if "%players%" == "2" if %key% == 100 set /a xp2+=50 & goto gameCls
	if "%players%" == "2" if %key% == 97 set /a xp2-=50 & goto gameCls
	if "%players%" == "2" if %key% == 115 set /a yp2+=50 & goto gameCls
	if %key% == 112 goto pause
	goto gameLoop

:pause
	lib\insertbmp /p:"gfx\background.bmp" /z:400
	set settings=menu
	cls
	echo Pause
	echo.
	lib\cmdmenusel f1%f0 "Continue" "New Game" "Help" "Main Menu"
	if %ERRORLEVEL% == 1 goto gameCls
	if %ERRORLEVEL% == 2 set lifes=3 & set playerOne=0 & set playerTwo=0 & set points=0 & goto gamePrepare
	if %ERRORLEVEL% == 3 goto help
	if %ERRORLEVEL% == 4 set lifes=3 & set playerOne=0 & set playerTwo=0 & set points=0 & goto menu

:gameOver
	if %points% gtr %highScore% set highScore=%points% & lib\batbox /g 32 20 /c 0x0f /d "New High Score^!" & goto highScore
	lib\batbox /g 35 20 /c 0x0f /d "Game Over"

:highScore
	lib\bg sleep 2000
	pause >nul
	call save
	set lifes=3
	set playerOne=0
	set playerTwo=0
	set points=0
	cls & call cls
	goto menu

:settings
	lib\insertbmp /p:"gfx\background.bmp" /z:400
	lib\insertbmp /p:"gfx\logo.bmp" /z:400
	cls
	echo.
	echo.
	echo.
	echo.
	echo.
	lib\cmdmenusel f1%f0 "Remove High Score" "Back"
	if %ERRORLEVEL% == 1 goto resetWarning
	if %ERRORLEVEL% == 2 goto menu

:resetWarning
	lib\insertbmp /p:"gfx\background.bmp" /z:400
	lib\insertbmp /p:"gfx\logo.bmp" /z:400
	cls
	echo.
	echo.
	echo.
	echo.
	echo.
	echo Warning^^!
	echo --------
	echo.
	echo Your high score will be lost.
	echo Are you sure you want to continue?
	echo.
	lib\cmdmenusel f1%f0 "Yes" "No"
	if %ERRORLEVEL% == 1 goto reset
	if %ERRORLEVEL% == 2 goto settings

:reset
	del %appdata%\Asteroid_Destroyer\1
	del %appdata%\Asteroid_Destroyer\2
	del %appdata%\Asteroid_Destroyer\3
	del %appdata%\Asteroid_Destroyer\4
	set highScore=0
	goto settings

:help
	cls
	lib\insertbmp /p:"gfx\background.bmp" /z:400
	lib\insertbmp /p:"gfx\logo.bmp" /z:400
	echo.
	echo.
	echo.
	echo.
	echo.
	echo Player 1
	echo --------
	echo Fire: Space
	echo Up: Up Arrow
	echo Down: Down Arrow
	echo Left: Left Arrow
	echo Right: Right Arrow
	echo.
	echo Player 2
	echo --------
	echo Fire: Q
	echo Up: W
	echo Down: S
	echo Left: A
	echo Right: D
	echo.
	echo Hotkeys
	echo -------
	echo Pause: P
	pause >nul
	if "%inGame%" == "0" goto menu
	goto pause