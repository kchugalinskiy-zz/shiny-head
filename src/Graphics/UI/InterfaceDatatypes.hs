module Graphics.UI.InterfaceDatatypes where

type Id = String
type Class = String

data FrameElement =
	Button Class Id |
	Label Class Id |
	Compound Class Id FrameConfiguration
	deriving (Show, Eq)

data FrameConfiguration =
	FrameConfiguration FrameType [FrameElement]
	deriving (Show, Eq)

data FrameType =
	Frame |
	Window
	deriving (Show, Eq, Ord)

data InterfaceDescription a =
	InterfaceDescription a FrameConfiguration
	deriving (Show)
