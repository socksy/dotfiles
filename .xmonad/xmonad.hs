import XMonad
import System.Exit
import XMonad.Hooks.EwmhDesktops 


import Data.List
import Data.Maybe (maybeToList)
import Control.Monad (when, join)

import XMonad.Actions.WorkspaceNames
import XMonad.Actions.SpawnOn
import XMonad.Actions.Volume
import XMonad.Actions.CycleWS
import XMonad.Prompt
import XMonad.Prompt.Window
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Layout.BinarySpacePartition
--import XMonad.Layout.Fullscreen as LF-- hiding (fullscreenEventHook)
import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral

import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Util.NamedWindows

import XMonad.Config.Desktop

import Graphics.X11.Xinerama
import Graphics.X11.ExtraTypes.XF86

myTerminal = "xfce4-terminal"

myBorderWidth = 1

altMask = mod1Mask

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    --, ((modm,               xK_p     ), spawn  "$(yeganesh -x -- -fn \"Dejavu Sans:size=8:antialias=true\")")
    , ((modm,               xK_p     ), spawn  "$(PATH=$HOME/bin:$PATH rofi -show run -font \"DejaVu Sans 25\")")

    -- run org capture (only works with doom)
    , ((modm, xK_c ), spawn "$($HOME/.emacs.d/bin/org-capture)")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

    -- find a window
    , ((modm              , xK_f     ), windowPromptGoto defaultXPConfig {font =  "xft:Dejavu Sans:size=8:antialias=true", height = fromIntegral 50, searchPredicate = isInfixOf, autoComplete = Just 100000})

    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ \"-3%\"")
    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +3%")
    ,((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    ,((0, xF86XK_AudioPrev), spawn "playerctl previous")
    ,((0, xF86XK_AudioPlay), spawn "playerctl play-pause")
    ,((0, xF86XK_AudioNext), spawn "playerctl next")

    ,((0, xF86XK_MonBrightnessUp), spawn "/home/ben/bin/backlight inc 10")
    ,((0, xF86XK_MonBrightnessDown), spawn "/home/ben/bin/backlight dec 10")

    -- rename current workspace
    , ((modm .|. shiftMask, xK_r      ), refresh)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- switch between screens because we use "view" instead of "greedyView" for mod+N
    , ((modm,               xK_Right), nextScreen)
    , ((modm,               xK_Left),  prevScreen)
    -- in practice with two desktops these are the same...
    , ((modm .|. shiftMask, xK_Right), swapNextScreen)
    , ((modm .|. shiftMask, xK_Left),  swapPrevScreen)

    --, ((modm,               xK_n     ), spawn "cat '12 3' > ~/.pomodoro_session")

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    --Move focus back to previous window
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

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


    -- keybindings to move around BSP
    , ((modm .|. altMask,                  xK_l  ), sendMessage $ ExpandTowards R)
    , ((modm .|. altMask,                  xK_h  ), sendMessage $ ExpandTowards L)
    , ((modm .|. altMask,                  xK_j  ), sendMessage $ ExpandTowards D)
    , ((modm .|. altMask,                  xK_k  ), sendMessage $ ExpandTowards U)
    , ((modm .|. altMask .|. controlMask , xK_l  ), sendMessage $ ShrinkFrom R)
    , ((modm .|. altMask .|. controlMask , xK_h  ), sendMessage $ ShrinkFrom L)
    , ((modm .|. altMask .|. controlMask , xK_j  ), sendMessage $ ShrinkFrom D)
    , ((modm .|. altMask .|. controlMask , xK_k  ), sendMessage $ ShrinkFrom U)
    , ((modm .|. altMask,                  xK_r  ), sendMessage Rotate)
    , ((modm,                              xK_s  ), sendMessage Swap)

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    -- also provided by desktopConfig, so maybe I should not bother here
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    --, ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm .|. shiftMask, xK_q     ), spawn "xfce4-session-logout" )

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "killall dzen2 && xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0, xK_minus, xK_equal])
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myWorkspaceNames = ["1", "2", "3", "focus", "5", "6", "7", "8", "9", "0", "-", "hide"]
myWorkspaces = clickable . (map dzenEscape) $ myWorkspaceNames
    where
        clickable l = [ "^ca(1,xdotool key super+" ++ k ++ ")" ++ ws ++ "^ca()" | (k,ws) <- zip wsKeys l ]
        wsKeys = (map show [1..9]) ++ ["0", "minus", "equal"]

myNormalBorderColour = "#dddddd"
myFocusedBorderColour = "#ff0000"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myLayout = tiled ||| Mirror tiled ||| spiral(6/7) ||| emptyBSP ||| Full
    where
        tiled = ResizableTall nmaster delta ratio []
        nmaster = 1
        delta = (3/100)
        ratio = (9/15)

-- myLogHook = workspaceNamesPP xmobarPP >>= dynamicLogString >>= xmonadPropLog
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   (dzenColor "#1B1D1E" "#ebac54" . pad)
      , ppVisible           =   (dzenColor "#1B1D1E" "white" . pad)
      , ppHidden            =   (dzenColor "white" "#1B1D1E" . pad)
      , ppHiddenNoWindows   =   (dzenColor "#7b7b7b" "#1B1D1E" . pad)
      , ppUrgent            =   (dzenColor "#ff0000" "#1B1D1E" . pad)
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   (dzenColor "#ebac54" "#1B1D1E" . pad)
      , ppTitle             =   ((" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape)
      , ppOutput            =   hPutStrLn h
    }


--myManageHooks = composeAll
--    [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
--    , className =? "Xfce4-notifyd" --> doIgnore 
--    , fullscreenManageHook]

getScreenDim :: Num a => Int -> IO (a, a, a, a)
getScreenDim n = do
  d <- openDisplay ""
  screens  <- getScreenInfo d
  closeDisplay d
  let rn = screens !!(min (abs n) (length screens - 1))
  case screens of
    []        -> return (0, 0, 2560, 1920) -- fallback
    [r]       -> return (fromIntegral $ rect_x r , fromIntegral $ rect_y r ,
                        fromIntegral $ rect_width r , fromIntegral $ rect_height r )
    otherwise -> return (fromIntegral $ rect_x rn, fromIntegral $ rect_y rn,
                        fromIntegral $ rect_width rn, fromIntegral $ rect_height rn)

dzenLocation :: Integer -> Integer -> (Integer, Integer, Integer, Integer)
dzenLocation w offset = (x1, x1W, x2, x2W)
  where
    x1 = offset
    x1W = round (fromIntegral w * 0.57)
    x2 = x1W + offset
    x2W = w - x1W

addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

main = do
    (offset, _, w, _) <- getScreenDim 0 -- which monitor to put the bar
    --let (x1, x1W, x2, x2W) = dzenLocation 2560 0 --default MBP leftmost settings
    let (x1, x1W, x2, x2W) = dzenLocation (toInteger w) offset --panned left screen width
    dzenBar <- spawnPipe $ "dzen2 -dock -h 24 -ta l -x "++ show x1 ++" -y 0 -w "++ show x1W ++" -bg '#1B1D1E' -e 'button2=;' -fn \"Dejavu Sans:size=8\""
    dzenBar2 <- spawnPipe $ "conky -c /home/ben/.xmonad/.conky_dzen | dzen2 -dock -h 24 -ta r -x "++show x2++" -y 0 -w "++show x2W++" -bg '#1B1D1E' -e 'button2=;' -fn \"Dejavu Sans:size=8\""
    xmonad $ docks $ desktopConfig 
            { terminal = myTerminal
            , focusFollowsMouse = myFocusFollowsMouse
            , borderWidth = myBorderWidth
            , modMask = mod4Mask
            , keys = myKeys
            , workspaces = myWorkspaces
            , normalBorderColor = myNormalBorderColour
            , focusedBorderColor = myFocusedBorderColour
            --,handleEventHook = ewmhDesktopsEventHook <+> LF.fullscreenEventHook <+> hintsEventHook
            ,handleEventHook = fullscreenEventHook
            --, handleEventHook = mconcat [fullscreenEventHook, docksEventHook, handleEventHook desktopConfig]
            --, handleEventHook = handleEventHook desktopConfig <+> fullscreenEventHook
            , logHook = myLogHook dzenBar
            --, manageHook = myManageHooks
            , startupHook = addEWMHFullscreen
            , layoutHook = smartSpacing 10 $ avoidStruts $ smartBorders $ myLayout }
