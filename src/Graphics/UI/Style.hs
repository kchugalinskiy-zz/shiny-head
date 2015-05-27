module Graphics.UI.Style where

import Graphics.UI.InterfaceDescription (Id, Class)

-- Usage example: ForId "Id" [Append ForId "Btn" Apply [Background RGB 255 0 0 ]]

data Selector =
	ForId Id [Modifier] |
	ForClass Class [Modifier]

data Modifier =
	Append Selector |
	Apply [Property]

data Color =
	ARGB Int Int Int Int |
	RGB Int Int Int |
	CMYK Int  Int Int Int

data Property =
	Background Color |
	Foreground Color