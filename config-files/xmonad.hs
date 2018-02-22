{-# OPTIONS -fno-warn-missing-signatures #-}

import XMonad

import XMonad.Actions.WindowGo
import XMonad.Actions.OnScreen

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName()
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleFloat

-- import qualified XMonad.StackSet as W

import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)

import System.IO


main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ def
    -- Xmobar needs this to show the window title, the workspaces, etc.
    { logHook           = dynamicLogWithPP xmobarPP
      { ppOutput        = hPutStrLn xmproc
      , ppTitle         = xmobarColor "green" "" . shorten 50
      }
    -- XMonad doesn't cover xmobar with this. It also activates class rules
    , manageHook        = myManageHook <+> manageDocks <+> manageHook def
    -- This prevents xmobar from being covered in the first workspace
    , handleEventHook   = docksEventHook <+> handleEventHook def
    , layoutHook        = myLayout 
    , workspaces        = myWorkspaces
    , terminal          = myTerminal
    , modMask           = myModMask
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor= myFocusedBorderColor
    }
    
    `additionalKeysP`
    [ ("M-w"                   , kill)
    , ("M-n"                   , sendMessage NextLayout)
    , ("M-f"                   , sendMessage $ Toggle FULL)
    , ("M-r"                 , spawn "if type xmonad; then xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
    , ("M-z"                   , spawn "setxkbmap es")
    , ("M-x"                   , spawn "setxkbmap us")
    , ("M-d"                   , spawn "dmenu_run") 
    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
    , ("<XF86AudioMute>"       , spawn "amixer set Master toggle")
    , ("<Print>"               , spawn "scrot")
    , ("M-<Space>"             , spawn myTerminal)
    , ("M-2"                   , switchAndRunOrRaise "code" editor editorClass)
    , ("M-3"                   , switchAndRunOrRaise "web" browser browserClass)
    ]

    `removeKeysP`
    [ "M-p" ]


    -- ++
    -- mod-{y,u,i} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{y,u,i} %! Move client to screen 1, 2, or 3
    -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_y, xK_u, xK_i] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    

editor               = "emacs"
editorClass          = "Emacs"
browser              = "chromium"
browserClass         = "Chromium"

myTerminal           = "urxvtc"
myNormalBorderColor  = "#FFFFFF"
myFocusedBorderColor = "#3137FD"
myModMask            = mod4Mask
myWorkspaces         = ["def", "code", "web"] ++ map show [4 :: Int .. 9]

myLayout             = smartBorders
                     -- workspace that can be toggled and will be activated by a signal
                       . mkToggle (NOBORDERS ?? FULL ?? EOT)
                     -- layouts that won't cover xmobar thanks to avoidStruts
                       $ avoidStruts (tall ||| simpleFloat)
  where tall = Tall 1 (3/100) (1/2)
                               
myManageHook = composeAll
  [ className =? "Gimp"                   --> doFloat
  , className =? "sun-awt-X11-XFramePeer" --> doFloat
  , className =? "trayer"                 --> doIgnore
  , className =? editorClass              --> doShift "code"
  , className =? browserClass             --> doShift "web"
  -- Fixes fullscreen players (like Youtube)
  , isFullscreen                          --> doFullFloat
  ]

switchAndRunOrRaise workspace executable windowClass =
  raiseMaybe (switchAndRun) (className =? windowClass)
    where switchAndRun = sequence_[switch, spawn executable]
            where switch = windows $ viewOnScreen 0 workspace
