module Graphics.UI.InterfaceDatatypes where

type Id = [String]
type Class = [String]

data FrameElement =
	Button Class Id |
	Label Class Id |
	Frame Class Id [FrameElement] |
	Window Class Id [FrameElement]
	deriving (Show, Eq)

getFrameElementId :: FrameElement -> Id
getFrameElementId (Button _ identifier) = identifier
getFrameElementId (Label _ identifier) = identifier
getFrameElementId (Frame _ identifier _) = identifier
getFrameElementId (Window _ identifier _) =identifier

getFrameElementClass :: FrameElement -> Class
getFrameElementClass (Button cl _) = cl
getFrameElementClass (Label cl _) = cl
getFrameElementClass (Frame cl _ _) = cl
getFrameElementClass (Window cl _ _) = cl