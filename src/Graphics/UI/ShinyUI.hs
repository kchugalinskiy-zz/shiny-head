{-# LANGUAGE ScopedTypeVariables #-}
module Graphics.UI.ShinyUI where

import Graphics.UI.Style
import Graphics.UI.InterfaceDatatypes
import Graphics.UI.InterfaceDescription

import Control.Exception (SomeException, bracket, catch)
import Foreign.Ptr (nullPtr)
import System.Exit (ExitCode(ExitSuccess), exitWith)
import System.Win32.DLL (getModuleHandle)
import qualified Graphics.Win32

execute :: InterfaceDescription a -> Style -> IO ()
execute interfaceDescription style = do
      Graphics.Win32.allocaPAINTSTRUCT $ \ lpps -> do
      	let topLevelElements = getTopLevelElements interfaceDescription
      	let topLevelWindows = filter (
      		\elem -> case elem of
      			Window _ _ _ -> True
      			otherwise -> False) topLevelElements
      	let hackOneWindow = (head topLevelWindows)
      	hwnd <- createWindow hackOneWindow style ((wndProc hackOneWindow) lpps (onPaint hackOneWindow))
      	messagePump hwnd

onPaint :: FrameElement -> Graphics.Win32.RECT -> Graphics.Win32.HDC -> IO ()
onPaint frameElement (_,_,w,h) hdc = do
   Graphics.Win32.setBkMode hdc Graphics.Win32.tRANSPARENT
   return ()

wndProc :: FrameElement -> Graphics.Win32.LPPAINTSTRUCT
	-> (Graphics.Win32.RECT -> Graphics.Win32.HDC -> IO ()) -- on paint action
        -> Graphics.Win32.HWND
        -> Graphics.Win32.WindowMessage
	-> Graphics.Win32.WPARAM
	-> Graphics.Win32.LPARAM
	-> IO Graphics.Win32.LRESULT
wndProc frameElement lpps onPaint hwnd wmsg wParam lParam
 | wmsg == Graphics.Win32.wM_DESTROY = do
     Graphics.Win32.sendMessage hwnd Graphics.Win32.wM_QUIT 1 0
     return 0
 | wmsg == Graphics.Win32.wM_PAINT && hwnd /= nullPtr = do
     r <- Graphics.Win32.getClientRect hwnd
     paintWith lpps hwnd (onPaint r)
     return 0
 | otherwise =
     Graphics.Win32.defWindowProc (Just hwnd) wmsg wParam lParam

createWindow :: FrameElement -> Style -> Graphics.Win32.WindowClosure -> IO Graphics.Win32.HWND
createWindow frameElement style wndProc = do
  let winClass = Graphics.Win32.mkClassName "STUB HERE"
  bgBrush      <- Graphics.Win32.createSolidBrush (Graphics.Win32.rgb 0 0 255)
  mainInstance <- getModuleHandle Nothing
  Graphics.Win32.registerClass
  	  ( Graphics.Win32.cS_VREDRAW + Graphics.Win32.cS_HREDRAW
	  , mainInstance
	  , Nothing
	  , Nothing
	  , Just bgBrush
	  , Nothing
	  , winClass
	  )
  let rect = getElementMinimalRect frameElement style
  w <- Graphics.Win32.createWindow
  		 winClass
		 "Hello, World example"
		 Graphics.Win32.wS_OVERLAPPEDWINDOW
		 (rectLeftX rect)
		 (rectTopY rect)
         (rectWidth rect)
		 (rectHeight rect)
		 Nothing      -- no parent, i.e, root window is the parent.
		 Nothing      -- no menu handle
		 mainInstance
		 wndProc
  Graphics.Win32.showWindow w Graphics.Win32.sW_SHOWNORMAL
  Graphics.Win32.updateWindow w
  return w
createWindow _ _ _ = error "Cannot create window for a non-window element"

messagePump :: Graphics.Win32.HWND -> IO ()
messagePump hwnd = Graphics.Win32.allocaMessage $ \ msg ->
  let pump = do
        Graphics.Win32.getMessage msg (Just hwnd)
		`catch` \ (_::SomeException) -> exitWith ExitSuccess
	Graphics.Win32.translateMessage msg
	Graphics.Win32.dispatchMessage msg
	pump
  in pump

paintWith :: Graphics.Win32.LPPAINTSTRUCT -> Graphics.Win32.HWND -> (Graphics.Win32.HDC -> IO a) -> IO a
paintWith lpps hwnd p =
  bracket
    (Graphics.Win32.beginPaint hwnd lpps)
    (const $ Graphics.Win32.endPaint hwnd lpps)
    p