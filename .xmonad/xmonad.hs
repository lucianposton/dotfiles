{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import qualified Data.Map as M

import XMonad
import XMonad.Actions.GridSelect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops as EWMH
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Decoration
import XMonad.Layout.Fullscreen as FS
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle
import XMonad.Layout.Simplest
import qualified XMonad.Layout.NoBorders as NB
import qualified XMonad.StackSet as W

-- Custom from ~/.xmonad/lib
import XMonad.Layout.MultiToggle.MyTabBar
import XMonad.Layout.NubModifier


-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "urxvtcd.sh || urxvtc || urxvt || xterm"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod3Mask
myAltMask       = mod1Mask

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
--myNumlockMask   = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#202030"
myFocusedBorderColor = "#A0A0D0"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. myAltMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch arbitrary script
    --, ((modm,               xK_f     ), spawn "~/doit.sh")
    , ((modm,               xK_o     ), spawn "ss=/tmp/img-$(date --utc +%FT%T.%3NZ).png; maim -B -i $(xdotool getactivewindow) $ss; imgurbash2 $ss")
    , ((modm .|. myAltMask, xK_o     ), spawn "ss=/tmp/img-$(date --utc +%FT%T.%3NZ).png; maim -B -s $ss; imgurbash2 $ss")
    , ((modm .|. shiftMask, xK_o     ), spawn "color-picker")

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch gmrun
    , ((modm .|. myAltMask, xK_p     ), spawn "gmrun")

    -- launch GridSelect
    , ((modm,               xK_g     ), goToSelected defaultGSConfig)

    -- launch GridSelect w/ favorites
    , ((modm .|. myAltMask, xK_g     ), spawnSelected defaultGSConfig ["firefox", "/home/poston/eclipse/eclipse"])

    -- close focused window
    , ((modm .|. myAltMask, xK_c     ), kill)

    -- Toggle TabBarDecoration
    , ((modm,               xK_x     ), sendMessage $ Toggle MYTABBAR)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. myAltMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. myAltMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. myAltMask, xK_k     ), windows W.swapUp    )

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
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. myAltMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm               .|. shiftMask, xK_q     ), restart "xmonad" True)

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, myAltMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_q, xK_w, xK_e, xK_r] [0..] -- monitor order
        , (f, m) <- [(W.view, 0), (W.shift, myAltMask)]]
    ++

    --
    -- XFree86 keysyms
    --
    [ ((0      , xF86XK_AudioMute         ), spawn "pactl set-sink-mute $(pacmd list-sinks|awk '/\\* index:/{ print $3 }') toggle")
    , ((0      , xF86XK_AudioRaiseVolume  ), spawn "pactl set-sink-volume $(pacmd list-sinks|awk '/\\* index:/{ print $3 }') +5%")
    , ((0      , xF86XK_AudioLowerVolume  ), spawn "pactl set-sink-volume $(pacmd list-sinks|awk '/\\* index:/{ print $3 }') -5%")
    ]


button6 = 6 :: Button
button7 = 7 :: Button
button8 = 8 :: Button
button9 = 9 :: Button
button10 = 10 :: Button
button11 = 11 :: Button
button12 = 12 :: Button
button13 = 13 :: Button
button14 = 14 :: Button
button15 = 15 :: Button

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w))

    -- launch arbitrary script
    --, ((0,       button10), (\w -> spawn "~/doit.sh"))

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
-- TODO http://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Layout-PerScreen.html
myLayoutHook = nubModifier $ avoidStruts $ mkToggle (single MYTABBAR)
        (tiled |||
        Mirror tiled |||
        NB.noBorders Simplest)
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
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

myEwmhDesktopsEventHook :: Event -> X All
myEwmhDesktopsEventHook e@(ClientMessageEvent
    {ev_message_type = mt}) = do
    a_aw <- getAtom "_NET_ACTIVE_WINDOW"
    if mt == a_aw
        then return (All True)
        else EWMH.ewmhDesktopsEventHook e
myEwmhDesktopsEventHook e = EWMH.ewmhDesktopsEventHook e

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
myLogHook = dynamicLogString xmobarPP >>= xmonadPropLog

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook = return ()

------------------------------------------------------------------------
-- Setup Fullscreen support

--myFullscreenSupport :: LayoutClass l Window =>
--  XConfig l -> XConfig (ModifiedLayout FullscreenFull l)
myFullscreenSupport c = c {
      handleEventHook = handleEventHook c <+> FS.fullscreenEventHook
    , manageHook = manageHook c <+> FS.fullscreenManageHook
--    , layoutHook = FS.fullscreenFull $ layoutHook c
  }

------------------------------------------------------------------------
-- Setup EWMH

myEwmh :: XConfig a -> XConfig a
myEwmh c = c {
      startupHook     = startupHook c
--                        <+> myEwmhStartup
                        <+> EWMH.ewmhDesktopsStartup
    , handleEventHook = handleEventHook c
--                        <+> EWMH.fullscreenEventHook
--                        <+> EWMH.ewmhDesktopsEventHook
                        <+> myEwmhDesktopsEventHook
    , logHook         = logHook c
                        <+> EWMH.ewmhDesktopsLogHook
}

myEwmhStartup :: X ()
myEwmhStartup = withDisplay $ \dpy -> do
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    c <- getAtom "ATOM"
    supp <- mapM getAtom ["_NET_WM_STATE_HIDDEN"
                         ,"_NET_WM_STATE_FULLSCREEN"
                         ,"_NET_NUMBER_OF_DESKTOPS"
                         ,"_NET_CLIENT_LIST"
                         ,"_NET_CLIENT_LIST_STACKING"
                         ,"_NET_CURRENT_DESKTOP"
                         ,"_NET_DESKTOP_NAMES"
                         ,"_NET_ACTIVE_WINDOW"
                         ,"_NET_WM_DESKTOP"
                         ,"_NET_WM_STRUT"
                         ]
    io $ changeProperty32 dpy r a c propModeReplace (fmap fromIntegral supp)

    setWMName "xmonad"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

main = xmonad $ myEwmh $ docks $ myFullscreenSupport myDefaultConfig

------------------------------------------------------------------------
-- Default config

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
myDefaultConfig = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
--        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayoutHook,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
