module Graphics.UI.Style where

import Graphics.UI.Event
import Graphics.UI.InterfaceDatatypes (Id, Class, getFrameElementId, getFrameElementClass, FrameElement)

import Data.Maybe

-- Usage example: ForId "Id" [Append ForId "Btn" Apply [Background RGB 255 0 0 ]]

type Style = [Selector]

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

type Size = Int

data Rect =
	Rect { rectLeftX :: Maybe Size, rectTopY :: Maybe Size, rectWidth :: Maybe Size, rectHeight :: Maybe Size }

class ProgramState s where
	applyFunction :: s -> s
	applyFunctionIO :: s -> IO (s)

data Property =
	forall s. ProgramState s => PureEvent EventTransaction (s -> s) |
	forall s. ProgramState s => DirtyEvent EventTransaction (s -> IO (s)) |
	Background Color |
	Foreground Color |
	MinimalRect Rect |
	RecommendedRect Rect |
	MaximalRect Rect

getElementMinimalRect :: FrameElement -> Style -> Rect
getElementMinimalRect frameElement style =
		Rect Nothing Nothing (Just 200) (Just 200)
	where
		elementId = getFrameElementId frameElement
		elementClass = getFrameElementClass frameElement