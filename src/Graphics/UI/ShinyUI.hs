module Graphics.UI.ShinyUI where

import Graphics.UI.Style
import Graphics.UI.InterfaceDescription

execute :: InterfaceDescription a -> Style -> IO ()
execute _ _ = do
	return ()