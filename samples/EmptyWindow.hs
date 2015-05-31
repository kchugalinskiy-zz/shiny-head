module Main where

import Graphics.UI.ShinyUI
import Graphics.UI.InterfaceDescription

main :: IO ()
main = do
	let interface = window "WindowClass" "WindowId" $ do return ()
	let style = []
	execute interface style