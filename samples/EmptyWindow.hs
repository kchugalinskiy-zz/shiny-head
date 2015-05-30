module Main where

import Graphics.UI.ShinyUI
import Graphics.UI.InterfaceDescription

main :: IO ()
main = do
	let interface = window "WindowClass" "WindowId" $ do
			label "Class1" "SomeTextLabel"
			button "Class2" "OkButton"
	let style = []
	execute interface style