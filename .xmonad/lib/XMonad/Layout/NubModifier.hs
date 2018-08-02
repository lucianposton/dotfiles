{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

----------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Layout.NubModifier
-- Copyright   :  
-- License     :  
--
-- Maintainer  :  
-- Stability   :  unstable
-- Portability :  not portable
--
-- Removes windows in same position e.g. background windows in fullscreen.
--
-----------------------------------------------------------------------------
module XMonad.Layout.NubModifier
       ( -- * Usage
         -- $usage
         nubModifier
       ) where

import Data.Function (on)
import Data.List (nubBy)
import XMonad
import XMonad.Layout.LayoutModifier

-- $usage
-- Edit your @layoutHook@ by adding the @NubModifier@ layout modifier:
--
-- > myLayout = NubModifier (Tall 1 (3/100) (1/2)) ||| Full ||| etc..
-- > main = xmonad def { layoutHook = myLayout }

data NubModifier a = NubModifier deriving (Show, Read)

instance LayoutModifier NubModifier a where
    modifyLayout _ wksp rect = do
        (wrs, mL) <- runLayout wksp rect
        return (nubBy ((==) `on` snd) wrs, mL)

-- | Apply the @NubModifier@ layout modifier.
nubModifier = ModifiedLayout $ NubModifier
