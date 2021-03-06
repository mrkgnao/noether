{-# LANGUAGE CPP               #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE Safe              #-}

module Lemmata.Functor (
  Functor(..),
  ($>),
  (<$>),
  (<<$>>),
  void,
) where

import           Data.Function ((.))

#if MIN_VERSION_base(4,7,0)
import           Data.Functor  (Functor (..), void, ($>), (<$>))
#else
import           Data.Functor  (Functor (..), (<$>))

import           Data.Function (flip)

infixl 4 $>

($>) :: Functor f => f a -> b -> f b
($>) = flip (<$)

void :: Functor f => f a -> f ()
void x = () <$ x
#endif

infixl 4 <<$>>

(<<$>>) :: (Functor f, Functor g) => (a -> b) -> f (g a) -> f (g b)
(<<$>>) = fmap . fmap
