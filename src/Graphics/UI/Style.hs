module Graphics.UI.Style where

import Graphics.UI.Event
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

class ProgramState s where
	applyFunction :: s -> s
	applyFunctionIO :: s -> IO (s)

data Property =
	forall s. ProgramState s => PureEvent EventTransaction (s -> s) |
	forall s. ProgramState s => DirtyEvent EventTransaction (s -> IO (s)) |
	Background Color |
	Foreground Color