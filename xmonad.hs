-- Abijr's config...
-- happy hacking!
--
-- Copied some stuff (dzen layout ) from and1's config and modded my own icons from someone else (cannot remember who, but if they're yours email me and i'll include you here...).
 
import XMonad
import System.Exit
import System.IO
 
import XMonad.Hooks.FadeInactive
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import IO
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutHints
import XMonad.Layout.PerWorkspace
import XMonad.ManageHook
import XMonad.Util.Run
import XMonad.Layout.Spacing

import XMonad.Layout.TwoPane

import XMonad.Util.EZConfig
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "xterm"
 
-- Width of the window border in pixels.
--
myBorderWidth   = 2
 
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask
 
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
myWorkspaces = ["all", "www", "code", "mcode"] ++ map show [5..9]
--
--myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
 
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#28241E"
myFocusedBorderColor = "#B47700"
 
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
 
    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenuz")

	-- launch thunar
	, ((modm, 				xK_w	 ), spawn "thunar")
 
    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "urxvt -e ncmpcpp")
 
    -- close focused window 
    , ((modm .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((mod4Mask,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((mod4Mask,               xK_k     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
 
    -- toggle the status bar gap
    -- TODO, update this binding with avoidStruts , ((modm , xK_b ), sendMessage ToggleStruts)
 
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    , ((modm              , xK_q     ), restart "xmonad" True)
    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
   -- ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    --[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
     --   | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      --  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
 
------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = spacing 2 $ tiled |||  Full ||| TwoPane (3/100) (1/2) ||| Mirror tiled
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll .concat $
    [ [className =? "MPlayer"        --> doFloat]
    , [className =? "Gimp"           --> doFloat]
    , [resource  =? "desktop_window" --> doIgnore]
	, [title	 =? "Buddy List" 	 --> doShift "www" ]
	, [className =? "Vimperator"	 --> doShift "www" ]
    , [resource  =? "stalonetray"    --> doIgnore]
    , [resource  =? "kdesktop"       --> doIgnore] 
	]
 
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
 
 
------------------------------------------------------------------------
-- Status bars and logging
 
-- Color, font and iconpath definitions:
--
myFont = "-xos4-terminus-medium-r-normal-*-14-*-*-*-c-*-iso10646-1"
myIconDir = "/home/and1/.dzen"
myDzenFGColor = "#555555"
myDzenBGColor = "#3F3F3F"
myNormalFGColor = "#aaaaaa"
myNormalBGColor = "#3F3F3F"
myFocusedFGColor = "#f0f0f0"
myFocusedBGColor = "#333333"
myUrgentFGColor = "#0099ff"
myUrgentBGColor = "#0077ff"
myIconFGColor = "#777777"
myIconBGColor = ""
mySeperatorColor = "#555555"
myGreen = "#688668"
myGray = "#3F3F3F"
myGreen2 = "#000000"
myBlue = "#84ADB4"
--Status bar with dzen 
 
myDzenPP h = defaultPP
    { ppCurrent = wrap ("^bg(" ++ myGreen2 ++ ")^fg(" ++ myGreen ++ ")[^fg()") ("^fg(" ++ myGreen ++ ")]^fg()^bg()") 
    , ppVisible = wrap ("^fg(" ++ myNormalFGColor ++ ")^bg(" ++ myFocusedBGColor ++ ")^p()^fg(" ++ myNormalFGColor ++ ")") "^fg()^bg()^p()"
    , ppHidden = wrap ("^fg()^bg()") "^fg()^bg()^p()" 
    , ppHiddenNoWindows = wrap ("^fg(" ++ myNormalBGColor ++ "") (")") 
    , ppUrgent = wrap ("^fg(" ++ myUrgentFGColor ++ ")^bg()^p()") "^fg()^bg()^p()" . \wsId -> if (':' `elem` wsId) then drop 2 wsId else wsId
    , ppSep = " "
    , ppWsSep = " "
    , ppTitle = dzenColor ("" ++ myNormalFGColor ++ "") "" . wrap "< " " >"
    , ppLayout = wrap ("^bg()^fg(" ++ myBlue ++ ").| ") (" |.^fg()^bg()") . 
        (\x -> case x of
        "Spacing 2 Tall" -> "Tall"
        "Spacing 2 Full" -> "Full"
        "Spacing 2 TwoPane" -> "2Pane"
        "Spacing 2 Mirror Tall" -> "MTall" 
        _ -> x
        )
    , ppOutput = hPutStrLn h
    }


------------------------------------------------------------------------
-- Startup hook
 
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()
 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
		dzen <- spawnPipe "dzen2 -e '' -x '0' -h '14' -w '500' -ta l -fg '#aaaaaa' -bg '#3F3F3F' -fn -*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*"
		spawnPipe "stalonetray"
		spawnPipe "dzonky"
		xmonad $ defaultConfig
			{
 
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
 
      -- simple stuff
		
    	manageHook = myManageHook <+> manageDocks
        , layoutHook = avoidStruts  $  myLayout
        , logHook = dynamicLogWithPP $ myDzenPP dzen, 

        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
 
      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
 
      -- hooks, layouts
        startupHook        = myStartupHook
    }
